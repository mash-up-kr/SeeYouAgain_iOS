//
//  CategoryBottomSheetCore.swift
//  Main
//
//  Created by 김영균 on 2023/06/08.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import CombineExt
import Common
import ComposableArchitecture
import Foundation
import Models
import Services

public struct CategoryBottomSheetState: Equatable {
  var allCategories: [CategoryType] = CategoryType.allCases
  var selectedCategories: [CategoryType] = []
  public var isPresented: Bool = false
  var successToastMessage: String?
  var failureToastMessage: String?
  
  public init() {}
}

public enum CategoryBottomSheetAction {
  // MARK: - User Action
  case categoryTapped(CategoryType)
  case updateButtonTapped
  
  // MARK: - Inner Business Action
  case _updateCategoires([String])
  case _categoriesIsUpdated
  case _presentSuccessToast(String)
  case _presentFailureToast(String)
  case _hideSuccessToast
  case _hideFailureToast
  
  // MARK: - Inner SetState Action
  case _setSelectedCategories([CategoryType])
  case _setIsPresented(Bool)
  case _setSuccessToastMessage(String?)
  case _SetFailureToastMessage(String?)
}

public struct CategoryBottomSheetEnvironment {
  fileprivate let mainQueue: AnySchedulerOf<DispatchQueue>
  fileprivate let categoryService: CategoryService
  
  public init(
    mainQueue: AnySchedulerOf<DispatchQueue>,
    categoryService: CategoryService
  ) {
    self.mainQueue = mainQueue
    self.categoryService = categoryService
  }
}

public let categoryBottomSheetReducer: Reducer<
  CategoryBottomSheetState,
  CategoryBottomSheetAction,
  CategoryBottomSheetEnvironment
> = Reducer { state, action, env in
  struct SuccessToastCancelID: Hashable {}
  struct FailureToastCancelID: Hashable {}
  
  switch action {
  case let .categoryTapped(category):
    if state.selectedCategories.contains(category) {
      return Effect(value: ._setSelectedCategories(state.selectedCategories.filter { $0 != category }))
    } else {
      var updatedSelectedCategories = state.selectedCategories
      updatedSelectedCategories.append(category)
      return Effect(value: ._setSelectedCategories(updatedSelectedCategories))
    }
    
  case .updateButtonTapped:
    let selectedCategories = state.selectedCategories.map { $0.uppercasedName }
    return Effect(value: ._updateCategoires(selectedCategories))
    
  case let ._updateCategoires(categories):
    return env.categoryService.updateCategories(categories)
      .catchToEffect()
      .flatMapLatest { result -> Effect<CategoryBottomSheetAction, Never> in
        switch result {
        case .success:
          return Effect.concatenate([
            Effect(value: ._categoriesIsUpdated),
            Effect(value: ._presentSuccessToast("관심 키워드가 변경되었어요."))
          ])
          
        case .failure:
          return Effect(value: ._presentFailureToast("인터넷이 불안정해서 변경되지 못했어요."))
        }
      }
      .eraseToEffect()
    
  case ._categoriesIsUpdated:
    return Effect(value: ._setIsPresented(false))
    
  case let ._presentSuccessToast(toastMessage):
    return .concatenate(
      Effect(value: ._setSuccessToastMessage(toastMessage)),
      Effect.cancel(id: SuccessToastCancelID()),
      Effect(value: ._hideSuccessToast)
        .delay(for: 2, scheduler: env.mainQueue)
        .eraseToEffect()
        .cancellable(id: SuccessToastCancelID(), cancelInFlight: true)
    )
    
  case let ._presentFailureToast(toastMessage):
    return .concatenate(
      Effect(value: ._SetFailureToastMessage(toastMessage)),
      Effect.cancel(id: FailureToastCancelID()),
      Effect(value: ._hideFailureToast)
        .delay(for: 2, scheduler: env.mainQueue)
        .eraseToEffect()
        .cancellable(id: FailureToastCancelID(), cancelInFlight: true)
    )
    
  case ._hideSuccessToast:
    return Effect(value: ._setSuccessToastMessage(nil))
    
  case ._hideFailureToast:
    return Effect(value: ._SetFailureToastMessage(nil))
    
  case let ._setSelectedCategories(categories):
    state.selectedCategories = categories
    return .none
    
  case let ._setIsPresented(isPresented):
    state.isPresented = isPresented
    return .none
    
  case let ._setSuccessToastMessage(message):
    state.successToastMessage = message
    return .none
    
  case let ._SetFailureToastMessage(message):
    state.failureToastMessage = message
    return .none
  }
}

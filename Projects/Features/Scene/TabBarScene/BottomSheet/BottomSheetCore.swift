//
//  BottomSheetCore.swift
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
  var toastMessage: String?
  
  public init() {}
}

public enum CategoryBottomSheetAction {
  // MARK: - User Action
  case categoryTapped(CategoryType)
  case updateButtonTapped
  
  // MARK: - Inner Business Action
  case _updateCategoires([String])
  case _categoriesIsUpdated
  case _presentToast(String)
  case _hideToast
  
  // MARK: - Inner SetState Action
  case _setSelectedCategories([CategoryType])
  case _setIsPresented(Bool)
  case _setToastMessage(String?)
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

enum CategoryBottomSheetID: Hashable {
  case _updateCategoires
  case _setCategoryToast
}

public let categoryBottomSheetReducer: Reducer<
  CategoryBottomSheetState,
  CategoryBottomSheetAction,
  CategoryBottomSheetEnvironment
> = Reducer { state, action, env in
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
          return Effect(value: ._categoriesIsUpdated)
          
        case .failure:
          return Effect(value: ._presentToast("인터넷이 불안정해서 변경되지 못했어요."))
        }
      }
      .eraseToEffect()
    
  case ._categoriesIsUpdated:
    return Effect(value: ._setIsPresented(false))
    
  case let ._presentToast(toastMessage):
    return .concatenate(
      Effect(value: ._setToastMessage(toastMessage)),
      Effect.cancel(id: CategoryBottomSheetID._setCategoryToast),
      Effect(value: ._hideToast)
        .delay(for: 2, scheduler: env.mainQueue)
        .eraseToEffect()
        .cancellable(id: CategoryBottomSheetID._setCategoryToast, cancelInFlight: true)
    )
    
  case ._hideToast:
    return Effect(value: ._setToastMessage(nil))
    
  case let ._setSelectedCategories(categories):
    state.selectedCategories = categories
    return .none
    
  case let ._setIsPresented(isPresented):
    state.isPresented = isPresented
    return .none
    
  case let ._setToastMessage(message):
    state.toastMessage = message
    return .none
  }
}

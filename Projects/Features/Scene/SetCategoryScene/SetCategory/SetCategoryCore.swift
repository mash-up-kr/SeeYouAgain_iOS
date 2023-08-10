//
//  SetCategoryCore.swift
//  SetCategory
//
//  Created by GREEN on 2023/04/28.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Combine
import Common
import ComposableArchitecture
import Foundation
import Services

public struct SetCategoryState: Equatable {
  var allCategories: [CategoryType] = CategoryType.allCases
  var selectedCategories: [CategoryType]
  var bottomButtonTitle: String {
    if selectedCategories.isEmpty {
      return "선택"
    } else {
      return "\(selectedCategories.count)개 선택"
    }
  }
  var isSelectButtonEnabled: Bool {
    !selectedCategories.isEmpty
  }
  var toastMessage: String?
  
  public init(selectedCategories: [CategoryType] = []) {
    self.selectedCategories = selectedCategories
  }
}

public enum SetCategoryAction: Equatable {
  // MARK: - User Action
  case categoryTapped(CategoryType)
  case selectButtonTapped
  
  // MARK: - Inner Business Action
  case _saveConnectHistory
  case _sendSelectedCategory
  case _presentToast(String)
  case _hideToast
  case _saveUserID(String)
  
  // MARK: - Inner SetState Action
  case _setSelectedCategories([CategoryType])
  case _setToastMessage(String?)
}

public struct SetCategoryEnvironment {
  let mainQueue: AnySchedulerOf<DispatchQueue>
  let userDefaultsService: UserDefaultsService
  let categoryService: CategoryService
  
  public init(
    mainQueue: AnySchedulerOf<DispatchQueue>,
    userDefaultsService: UserDefaultsService,
    categoryService: CategoryService
  ) {
    self.mainQueue = mainQueue
    self.userDefaultsService = userDefaultsService
    self.categoryService = categoryService
  }
}

public let setCategoryReducer = Reducer.combine([
  Reducer<SetCategoryState, SetCategoryAction, SetCategoryEnvironment> { state, action, env in
    struct SetCategoryToastCancelID: Hashable {}
    
    switch action {
    case let .categoryTapped(category):
      if state.selectedCategories.contains(category) {
        return Effect(value: ._setSelectedCategories(state.selectedCategories.filter { $0 != category }))
      } else {
        state.selectedCategories.append(category)
      }
      return .none
      
    case .selectButtonTapped:
      return Effect(value: ._saveConnectHistory)
      
    case ._saveConnectHistory:
      return env.userDefaultsService.save(.registered, true)
        .map({ _ -> SetCategoryAction in
          return ._sendSelectedCategory
        })
      
    case ._sendSelectedCategory:
      let selectedCategories = state.selectedCategories.map { $0.uppercasedName }
      
      return env.categoryService.saveCategory(selectedCategories)
        .catchToEffect()
        .flatMapLatest { result -> Effect<SetCategoryAction, Never> in
          switch result {
          case let .success(data):
            return Effect(value: ._saveUserID(data.uniqueId))

          case .failure:
            return Effect(value: ._presentToast("인터넷 연결 상태가 불안정합니다."))
          }
        }
        .eraseToEffect()
      
    case let ._presentToast(toastMessage):
      return .concatenate([
        Effect(value: ._setToastMessage(toastMessage)),
        .cancel(id: SetCategoryToastCancelID()),
        Effect(value: ._hideToast)
          .delay(for: 2, scheduler: env.mainQueue)
          .eraseToEffect()
          .cancellable(id: SetCategoryToastCancelID(), cancelInFlight: true)
      ])
      
    case ._hideToast:
      return Effect(value: ._setToastMessage(nil))
      
    case let ._saveUserID(userID):
      return Effect.merge(
        env.userDefaultsService.saveUserID(userID).fireAndForget(),
        env.userDefaultsService.saveCurrentMode(Mode.basic.rawValue).fireAndForget(),
        env.userDefaultsService.save(UserDefaultsKey.hasCompanyModeHistory, false).fireAndForget()
      )
      
    case let ._setSelectedCategories(categories):
      state.selectedCategories = categories
      return .none
      
    case let ._setToastMessage(toastMessage):
      state.toastMessage = toastMessage
      return .none
    }
  }
])

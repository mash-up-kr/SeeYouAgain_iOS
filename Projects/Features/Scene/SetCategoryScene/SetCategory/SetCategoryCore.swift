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
  var allCategories: [String] = CategoryType.allCases.map {
    $0.rawValue
  }
  var selectedCategories: [String]
  var isSelectButtonEnabled: Bool {
    !selectedCategories.isEmpty
  }
  var toastMessage: String?
  
  public init(selectedCategories: [String] = []) {
    self.selectedCategories = selectedCategories
  }
}

public enum SetCategoryAction: Equatable {
  // MARK: - User Action
  case categoryTapped(String)
  case selectButtonTapped
  
  // MARK: - Inner Business Action
  case _saveConnectHistory
  case _sendSelectedCategory
  case _presentToast(String)
  case _hideToast
  
  // MARK: - Inner SetState Action
  case _setSelectedCategories([String])
  case _setToastMessage(String?)
}

public struct SetCategoryEnvironment {
  // TODO: - 추후 회원가입 API 추가 필요
  let mainQueue: AnySchedulerOf<DispatchQueue>
  let userDefaultsService: UserDefaultsService
  
  public init(
    mainQueue: AnySchedulerOf<DispatchQueue>,
    userDefaultsService: UserDefaultsService
  ) {
    self.mainQueue = mainQueue
    self.userDefaultsService = userDefaultsService
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
      return env.userDefaultsService.save(true)
        .map({ _ -> SetCategoryAction in
          return ._sendSelectedCategory
        })
      
    case ._sendSelectedCategory:
      // TODO: - 추후 선택된 카테고리에 대해 회원 정보 (IDFV)를 담아 API 호출 연동 필요
      // TODO: - 위 API 호출 시 Response(성공/실패)에 따라 토스트 메시지 혹은 이동 로직 구분 필요
      // TODO: - 호출 응답 확인 후 상위 AppCoordinator에서 메인 화면으로 이동 로직 필요
      return .none
      
    case let ._presentToast(toastMessage):
      return .concatenate([
        Effect(value: ._setToastMessage(toastMessage)),
        .cancel(id: SetCategoryToastCancelID()),
        Effect(value: ._hideToast)
          // MARK: - 추후 토스트 지속 시간 가이드에 따라 변경 예정
          .delay(for: 2, scheduler: env.mainQueue)
          .eraseToEffect()
          .cancellable(id: SetCategoryToastCancelID(), cancelInFlight: true)
      ])
      
    case ._hideToast:
      return Effect(value: ._setToastMessage(nil))
      
    case let ._setSelectedCategories(categories):
      state.selectedCategories = categories
      return .none
      
    case let ._setToastMessage(toastMessage):
      state.toastMessage = toastMessage
      return .none
    }
  }
])

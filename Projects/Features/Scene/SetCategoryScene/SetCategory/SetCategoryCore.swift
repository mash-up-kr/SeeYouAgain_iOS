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

public struct SetCategoryState: Equatable {
  var allCategories: [String] = CategoryType.allCases.map {
    $0.rawValue
  }
  var selectedCategories: [String]
  var isAvailabledSelectButton: Bool {
    !selectedCategories.isEmpty
  }
  
  public init(selectedCategories: [String]) {
    self.selectedCategories = selectedCategories
  }
}

public enum SetCategoryAction: Equatable {
  // MARK: - User Action
  case categoryTapped(String)
  case selectButtonTapped
  
  // MARK: - Inner Business Action
  case sendSelectedCategory
  
  // MARK: - Inner SetState Action
  case setSelectedCategories([String])
}

public struct SetCategoryEnvironment {
  // TODO: - 추후 회원가입 API 추가 필요
  public init() {}
}

public let setCategoryReducer = Reducer.combine([
  Reducer<SetCategoryState, SetCategoryAction, SetCategoryEnvironment> { state, action, env in
    switch action {
    case let .categoryTapped(category):
      if state.selectedCategories.contains(category) {
        return Effect(value: .setSelectedCategories(state.selectedCategories.filter { $0 != category }))
      } else {
        state.selectedCategories.append(category)
      }
      return .none
      
    case .selectButtonTapped:
      return Effect(value: .sendSelectedCategory)
      
    case .sendSelectedCategory:
      // TODO: - 추후 선택된 카테고리에 대해 회원 정보를 담아 API 호출 연동 필요
      // TODO: - 호출 응답 확인 후 상위 AppCoordinator에서 메인 화면으로 이동 로직 필요
      return .none
      
    case let .setSelectedCategories(categories):
      state.selectedCategories = categories
      return .none
    }
  }
])

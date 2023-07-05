//
//  CategoryFilterBottomSheetCore.swift
//  Splash
//
//  Created by 김영균 on 2023/07/05.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Common
import ComposableArchitecture
import Foundation

public struct CategoryFilterBottomSheetState: Equatable {
  var allCateogires: [CategoryType]
  var selectedCategories: Set<CategoryType>
  var isPresented: Bool
  
  init(
    allCateogires: [CategoryType] = CategoryType.allCases,
    selectedCategories: Set<CategoryType> = [],
    isPresented: Bool = false
  ) {
    self.allCateogires = allCateogires
    self.selectedCategories = selectedCategories
    self.isPresented = isPresented
  }
}

public enum CategoryFilterBottomSheetAction {
  // MARK: User Action
  case confirmBottomButtonTapped
  case selectCategory(CategoryType)
  
  // MARK: Inner Business Action
  case _filter(Set<CategoryType>) // 상위 코어에 전달하는 액션.
  
  // MARK: Inner Set State Action
  case _setSelectedCategories(Set<CategoryType>)
  case _setIsPresented(Bool)
}

public struct CategoryFilterBottomSheetEnvironment {
  init() { }
}

public let categoryFilterBottomSheetReducer = Reducer<
  CategoryFilterBottomSheetState,
  CategoryFilterBottomSheetAction,
  CategoryFilterBottomSheetEnvironment
> { state, action, _ in
  switch action {
  case .confirmBottomButtonTapped:
    return Effect(value: ._filter(state.selectedCategories))
    
  case let .selectCategory(category):
    if state.selectedCategories.contains(category) {
      state.selectedCategories.remove(category)
    } else {
      state.selectedCategories.insert(category)
    }
    return .none
    
  case ._filter:
    return .none
    
  case let ._setSelectedCategories(selectedCategories):
    state.selectedCategories = selectedCategories
    return .none
    
  case let ._setIsPresented(isPresented):
    state.isPresented = isPresented
    return .none
  }
}

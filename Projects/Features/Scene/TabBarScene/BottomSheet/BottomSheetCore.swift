//
//  BottomSheetCore.swift
//  Main
//
//  Created by 김영균 on 2023/06/08.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import CombineExt
import ComposableArchitecture
import Models

public typealias Category = Models.Category

public struct CategoryBottomSheetState: Equatable {
  public var categories: [Category] = []
  public var isPresented: Bool = false
  
  public init() {}
}

public enum CategoryBottomSheetAction {
  // MARK: - User Action
  case updateButtonTapped

  // MARK: - Inner SetState Action
  case _toggleCategory(Category)
  case _setCategories([Category])
  case _setIsPresented(Bool)
}

public struct CategoryBottomSheetEnvironment {
  
}

public let categoryBottomSheetReducer: Reducer<
  CategoryBottomSheetState,
  CategoryBottomSheetAction,
  CategoryBottomSheetEnvironment
> = Reducer { state, action, env in
  switch action {
  case let ._toggleCategory(targetCategory):
    let updateCategories = state.categories.map { category in
      var updateCategory = category
      if targetCategory == updateCategory {
        updateCategory.isSelected.toggle()
      }
      return updateCategory
    }
    return Effect(value: ._setCategories(updateCategories))
    
  case let ._setCategories(categories):
    state.categories = categories
    return .none
    
  case let ._setIsPresented(isPresented):
    state.isPresented = isPresented
    return .none
    
  default:
    return .none
  }
}

//
//  MainCore.swift
//  Main
//
//  Created by GREEN on 2023/04/05.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import CombineExt
import ComposableArchitecture
import Foundation
import Models
import Services

public typealias Category = Models.Category

public struct MainState: Equatable {
  var categories: [Category] = Category.stub
  var bottomSheetShowed: Bool = false
  public init() { }
}

public enum MainAction {
  // MARK: - User Action
  case openBottomSheet
  case closeBottomSheet
  case updateButtonTapped
  
  // MARK: - Inner Business Action
  case updateCategories
  
  // MARK: - Inner SetState Action
  case toggleCategorySelected(Category)
  
  // MARK: - Child Action
}

public struct MainEnvironment {
  var mainQueue: AnySchedulerOf<DispatchQueue> = .main
  var userService: UserService = .live
  public init() {}
}

public let mainReducer = Reducer.combine([
  Reducer<MainState, MainAction, MainEnvironment> { state, action, env in
    switch action {
    case .openBottomSheet:
      state.bottomSheetShowed = true
      return .none
      
    case .closeBottomSheet:
      state.bottomSheetShowed = false
      return .none
      
    case .updateButtonTapped:
      return Effect.concatenate([
        Effect(value: .updateCategories),
        Effect(value: .closeBottomSheet)
      ])
      
    case .updateCategories:
      return .none
      
    case let .toggleCategorySelected(selection):
      state.categories = state.categories.map { category in
        var updateCategory = category
        if updateCategory.name == selection.name {
          updateCategory.isSelected.toggle()
        }
        return updateCategory
      }
      return .none
    }
  }
])

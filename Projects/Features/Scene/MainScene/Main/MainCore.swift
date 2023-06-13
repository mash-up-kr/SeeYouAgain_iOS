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
  var isLoading: Bool = false
  var categories: [Category] = []
  var letterScrollState: LetterScrollState?
  public init() { }
}

public enum MainAction {
  // MARK: - User Action
  case showCategoryBottomSheet([Category])
  
  // MARK: - Inner Business Action
  case _viewWillAppear
  case _fetchCategories
  case _fetchLetters
  case _updateCategories
  
  // MARK: - Inner SetState Action
  case _setIsLoading(Bool)
  case _setCategories([Category])
  
  // MARK: - Child Action
  case letterScrollAction(LetterScrollAction)
}

public struct MainEnvironment {  
  public init() {}
}

public let mainReducer = Reducer.combine([
  letterScrollReducer
    .optional()
    .pullback(
      state: \.letterScrollState,
      action: /MainAction.letterScrollAction,
      environment: { _ in LetterScrollEnvironmnet() }
    ),
  Reducer<MainState, MainAction, MainEnvironment> { state, action, env in
    switch action {
    case ._viewWillAppear:
      return Effect.concatenate([
        Effect(value: ._setIsLoading(true)),
        Effect(value: ._fetchCategories),
        Effect(value: ._fetchLetters),
        Effect(value: ._setIsLoading(false))
      ])
      
    case ._fetchCategories:
      state.categories = Category.stub
      return .none
      
    case ._fetchLetters:
      state.letterScrollState = .init()
      return .none
      
    case ._updateCategories:
      // TODO: update categories to sever
      return .none
      
    case let ._setIsLoading(isLoading):
      state.isLoading = isLoading
      return .none
      
    case let ._setCategories(categories):
      state.categories = categories
      return .none
      
    default:
      return .none
    }
  }
])

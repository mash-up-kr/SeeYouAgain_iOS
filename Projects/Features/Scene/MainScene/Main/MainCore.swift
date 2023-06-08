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
  public init() { }
}

public enum MainAction {
  // MARK: - User Action
  case openBottomSheet([Category])
  
  // MARK: - Inner Business Action
  case viewWillAppear
  case fetchCategories
  case updateCategories([Category])
  
  // MARK: - Inner SetState Action
  case setIsLoading(Bool)
}

public struct MainEnvironment {
  var mainQueue: AnySchedulerOf<DispatchQueue> = .main
  var userService: UserService = .live
  public init() {}
}

public let mainReducer = Reducer.combine([
  Reducer<MainState, MainAction, MainEnvironment> { state, action, env in
    switch action {
    case .viewWillAppear:
      return Effect.concatenate([
        Effect(value: .setIsLoading(true)),
        Effect(value: .fetchCategories),
        Effect(value: .setIsLoading(false))
      ])
      
    case .fetchCategories:
      state.categories = Category.stub
      return .none
      
    case let .updateCategories(categories):
      state.categories = categories
      return .none
      
    case let .setIsLoading(loading):
      state.isLoading = loading
      return .none
      
    default:
      return .none
    }
  }
])

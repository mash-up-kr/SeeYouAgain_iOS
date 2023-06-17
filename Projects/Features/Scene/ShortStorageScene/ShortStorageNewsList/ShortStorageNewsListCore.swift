//
//  ShortStorageNewsListCore.swift
//  Scene
//
//  Created by GREEN on 2023/04/28.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Combine
import ComposableArchitecture
import Foundation

public struct ShortStorageNewsListState: Equatable {
  public init() { }
}

public enum ShortStorageNewsListAction: Equatable {
  // MARK: - User Action
  case backButtonTapped
  
  // MARK: - Inner Business Action
  
  // MARK: - Inner SetState Action
  
  // MARK: - Child Action
}

public struct ShortStorageNewsListEnvironment {
  public init() {}
}

public let shortStorageNewsListReducer = Reducer.combine([
  Reducer<
  ShortStorageNewsListState,
  ShortStorageNewsListAction,
  ShortStorageNewsListEnvironment
  > { state, action, env in
    switch action {
    default: return .none
    }
  }
])

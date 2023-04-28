//
//  LongStorageNewsListCore.swift
//  Scene
//
//  Created by GREEN on 2023/04/28.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Combine
import ComposableArchitecture
import Foundation

public struct LongStorageNewsListState: Equatable {
  public init() { }
}

public enum LongStorageNewsListAction: Equatable {
  // MARK: - User Action
  
  // MARK: - Inner Business Action
  
  // MARK: - Inner SetState Action
  
  // MARK: - Child Action
}

public struct LongStorageNewsListEnvironment {
  public init() {}
}

public let longStorageNewsListReducer = Reducer.combine([
  Reducer<
  LongStorageNewsListState,
  LongStorageNewsListAction,
  LongStorageNewsListEnvironment
  > { state, action, env in
    switch action {
    }
  }
])

//
//  ShortStorageCardListCore.swift
//  Setting
//
//  Created by GREEN on 2023/04/28.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Combine
import ComposableArchitecture
import Foundation

public struct ShortStorageCardListState: Equatable {
  public init() { }
}

public enum ShortStorageCardListAction: Equatable {
  // MARK: - User Action
  
  // MARK: - Inner Business Action
  
  // MARK: - Inner SetState Action
  
  // MARK: - Child Action
}

public struct ShortStorageCardListEnvironment {
  public init() {}
}

public let shortStorageCardListReducer = Reducer.combine([
  Reducer<
  ShortStorageCardListState,
  ShortStorageCardListAction,
  ShortStorageCardListEnvironment
  > { state, action, env in
    switch action {
    default: return .none
    }
  }
])

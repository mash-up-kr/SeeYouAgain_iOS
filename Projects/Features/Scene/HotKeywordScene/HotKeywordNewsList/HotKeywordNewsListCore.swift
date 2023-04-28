//
//  HotKeywordNewsListCore.swift
//  Scene
//
//  Created by GREEN on 2023/04/28.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Combine
import ComposableArchitecture
import Foundation

public struct HotKeywordNewsListState: Equatable {
  public init() { }
}

public enum HotKeywordNewsListAction: Equatable {
  // MARK: - User Action
  
  // MARK: - Inner Business Action
  
  // MARK: - Inner SetState Action
  
  // MARK: - Child Action
}

public struct HotKeywordNewsListEnvironment {
  public init() {}
}

public let hotKeywordNewsListReducer = Reducer.combine([
  Reducer<
  HotKeywordNewsListState,
  HotKeywordNewsListAction,
  HotKeywordNewsListEnvironment
  > { state, action, env in
    switch action {
    }
  }
])

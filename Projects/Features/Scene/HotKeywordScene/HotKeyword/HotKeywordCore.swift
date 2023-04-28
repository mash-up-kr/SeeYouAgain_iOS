//
//  HotKeywordCore.swift
//  Scene
//
//  Created by GREEN on 2023/04/28.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Combine
import ComposableArchitecture
import Foundation

public struct HotKeywordState: Equatable {
  public init() { }
}

public enum HotKeywordAction: Equatable {
  // MARK: - User Action
  
  // MARK: - Inner Business Action
  
  // MARK: - Inner SetState Action
  
  // MARK: - Child Action
}

public struct HotKeywordEnvironment {
}

public let hotKeywordReducer = Reducer.combine([
  Reducer<HotKeywordState, HotKeywordAction, HotKeywordEnvironment> { state, action, env in
    switch action {
    }
  }
])

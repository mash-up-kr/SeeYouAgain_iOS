//
//  ShortsCompleteCore.swift
//  NewsList
//
//  Created by 안상희 on 2023/06/25.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import ComposableArchitecture

public struct ShortsCompleteState: Equatable {
  // TODO: 실데이터로 반영 필요
  var totalShorts: Int = 57
  
  public init() {}
}

public enum ShortsCompleteAction {
  // MARK: - User Action
  case backButtonTapped
  case completeButtonTapped
  
  // MARK: - Inner Business Action
  
  // MARK: - Inner SetState Action
  
  // MARK: - Child Action
}

public struct ShortsCompleteEnvironment {
  public init() {}
}

public let shortsCompleteReducer = Reducer.combine([
  Reducer<ShortsCompleteState, ShortsCompleteAction, ShortsCompleteEnvironment> { state, action, env in
    switch action {
    default: return .none
    }
  }
])

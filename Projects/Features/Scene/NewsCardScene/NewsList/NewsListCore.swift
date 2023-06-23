//
//  NewsListCore.swift
//  Scene
//
//  Created by GREEN on 2023/04/28.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Combine
import ComposableArchitecture
import Foundation

public struct NewsListState: Equatable {
  public var id: Int
  
  public init(
    id: Int
  ) {
    self.id = id
  }
}

public enum NewsListAction: Equatable {
  // MARK: - User Action
  case backButtonTapped
  
  // MARK: - Inner Business Action
  
  // MARK: - Inner SetState Action
  
  // MARK: - Child Action
}

public struct NewsListEnvironment {
  public init() {}
}

public let newsListReducer = Reducer.combine([
  Reducer<NewsListState, NewsListAction, NewsListEnvironment> { state, action, env in
    switch action {
    default: return .none
    }
  }
])

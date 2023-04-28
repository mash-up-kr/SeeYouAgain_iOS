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
  public init() { }
}

public enum NewsListAction: Equatable {
  // MARK: - User Action
  
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
    }
  }
])


//
//  NewsCardCore.swift
//  NewsList
//
//  Created by 안상희 on 2023/06/24.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Combine
import ComposableArchitecture
import Foundation
import Models

public struct NewsCardState: Equatable, Identifiable {
  public var id: Int
  public var news: News
}

public enum NewsCardAction: Equatable {
  // MARK: - User Action
  case rightButtonTapped
  case cardTapped
  
  // MARK: - Inner Business Action
  case _navigateWebView(String)
  
  // MARK: - Inner SetState Action
  
  // MARK: - Child Action
}

public struct NewsCardEnvironment {
  public init() {}
}

public let newsCardReducer = Reducer.combine([
  Reducer<NewsCardState, NewsCardAction, NewsCardEnvironment> { state, action, env in
    switch action {
    case .rightButtonTapped:
      return Effect(value: ._navigateWebView(state.news.newsLink))
      
    case .cardTapped:
      return Effect(value: ._navigateWebView(state.news.newsLink))
      
    default: return .none
    }
  }
])

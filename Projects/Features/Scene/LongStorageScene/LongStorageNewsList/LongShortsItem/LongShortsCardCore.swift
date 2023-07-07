//
//  LongShortsCardCore.swift
//  LongStorageNewsList
//
//  Created by 안상희 on 2023/06/25.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import ComposableArchitecture
import Models

public struct LongShortsCardState: Equatable, Identifiable {
  public var id: Int
  var news: News
  var isCardSelectable: Bool
  var isSelected: Bool
  
  public init(
    id: Int,
    news: News,
    isCardSelectable: Bool,
    isSelected: Bool
  ) {
    self.id = id
    self.news = news
    self.isCardSelectable = isCardSelectable
    self.isSelected = isSelected
  }
}

public enum LongShortsCardAction: Equatable {
  // MARK: - User Action
  case rightButtonTapped
  case cardTapped
  
  // MARK: - Inner Business Action
  case _navigateNewsList(String)
  
  // MARK: - Inner SetState Action
  
  // MARK: - Child Action
}

public struct LongShortsCardEnvironment {
  public init() {}
}

public let longShortsCardReducer = Reducer<
  LongShortsCardState,
  LongShortsCardAction,
  LongShortsCardEnvironment
>.combine([
  Reducer { state, action, env in
    switch action {
    case .rightButtonTapped:
      return Effect(value: ._navigateNewsList(state.news.newsLink))
      
    case .cardTapped:
      return Effect(value: ._navigateNewsList(state.news.newsLink))
      
    default: return .none
    }
  }
])

//
//  TodayShortsCardCore.swift
//  ShortStorageNewsList
//
//  Created by 안상희 on 2023/06/18.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import ComposableArchitecture
import Models

public struct TodayShortsCardState: Equatable {
  public var shortsNews: NewsCard
  public var isCardSelectable: Bool
  public var isSelected: Bool
  
  public init(
    shortsNews: NewsCard,
    isCardSelectable: Bool,
    isSelected: Bool
  ) {
    self.shortsNews = shortsNews
    self.isCardSelectable = isCardSelectable
    self.isSelected = isSelected
  }
}

public enum TodayShortsCardAction: Equatable {
  // MARK: - User Action
  case rightButtonTapped
  case cardTapped
  
  // MARK: - Inner Business Action
  case _navigateNewsList(String)
  
  // MARK: - Inner SetState Action
  
  // MARK: - Child Action
}

public struct TodayShortsCardEnvironment {
  init() {}
}

let todayShortsCardReducer = Reducer.combine([
  Reducer<TodayShortsCardState, TodayShortsCardAction, TodayShortsCardEnvironment> { state, action, env in
    switch action {
    case .rightButtonTapped:
      return Effect(value: ._navigateNewsList(state.shortsNews.hashtagString()))
      
    case .cardTapped:
      return Effect(value: ._navigateNewsList(state.shortsNews.hashtagString()))
      
    default: return .none
    }
  }
])

//
//  TodayShortsCardCore.swift
//  ShortStorageNewsList
//
//  Created by 안상희 on 2023/06/18.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import ComposableArchitecture

public struct TodayShortsCardState: Equatable {
  public var shortsNews: ShortsNews
  public var isCardSelectable: Bool
  
  public init(
    shortsNews: ShortsNews,
    isCardSelectable: Bool
  ) {
    self.shortsNews = shortsNews
    self.isCardSelectable = isCardSelectable
  }
}

public enum TodayShortsCardAction: Equatable {
  // MARK: - User Action
  case rightButtonTapped
  
  // MARK: - Inner Business Action
  
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
      return .none
      
    default: return .none
    }
  }
])

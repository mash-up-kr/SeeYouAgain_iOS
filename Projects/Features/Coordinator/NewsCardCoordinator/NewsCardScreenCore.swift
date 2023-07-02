//
//  NewsCardScreenCore.swift
//  CoordinatorKit
//
//  Created by GREEN on 2023/04/28.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import ComposableArchitecture
import NewsList
import Services
import TCACoordinators
import Web

public enum NewsCardScreenState: Equatable {
  case newsList(NewsListState)
  case web(WebState)
  case shortsComplete(ShortsCompleteState)
}

public enum NewsCardScreenAction: Equatable {
  case newsList(NewsListAction)
  case web(WebAction)
  case shortsComplete(ShortsCompleteAction)
}

internal struct NewsCardScreenEnvironment {
  fileprivate let newsCardService: NewsCardService
  
  internal init(newsCardService: NewsCardService) {
    self.newsCardService = newsCardService
  }
}

internal let newsCardScreenReducer = Reducer<
  NewsCardScreenState,
  NewsCardScreenAction,
  NewsCardScreenEnvironment
>.combine([
  newsListReducer
    .pullback(
      state: /NewsCardScreenState.newsList,
      action: /NewsCardScreenAction.newsList,
      environment: {
        NewsListEnvironment(newsCardService: $0.newsCardService)
      }
    ),
  webReducer
    .pullback(
      state: /NewsCardScreenState.web,
      action: /NewsCardScreenAction.web,
      environment: { _ in
        WebEnvironment()
      }
    ),
  shortsCompleteReducer
    .pullback(
      state: /NewsCardScreenState.shortsComplete,
      action: /NewsCardScreenAction.shortsComplete,
      environment: { _ in
        ShortsCompleteEnvironment()
      }
    )
])

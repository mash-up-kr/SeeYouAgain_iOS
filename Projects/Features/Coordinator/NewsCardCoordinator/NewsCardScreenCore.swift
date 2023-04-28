//
//  NewsCardScreenCore.swift
//  CoordinatorKit
//
//  Created by GREEN on 2023/04/28.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import ComposableArchitecture
import Services
import NewsList
import TCACoordinators

public enum NewsCardScreenState: Equatable {
  case newsList(NewsListState)
}

public enum NewsCardScreenAction: Equatable {
  case newsList(NewsListAction)
}

internal struct NewsCardScreenEnvironment {
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
      environment: { _ in
        NewsListEnvironment()
      }
    ),
])

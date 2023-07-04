//
//  NewsCardCoordinatorCore.swift
//  Coordinator
//
//  Created by GREEN on 2023/04/28.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import ComposableArchitecture
import NewsList
import Services
import SwiftUI
import TCACoordinators

public struct NewsCardCoordinatorState: Equatable, IndexedRouterState {
  public var routes: [Route<NewsCardScreenState>]
  
  public init(
    routes: [Route<NewsCardScreenState>] = [
      .root(
        .newsList(
          .init(
            shortsId: 0,
            keywordTitle: "",
            newsItems: []
          )
        ),
        embedInNavigationView: true
      )
    ]
  ) {
    self.routes = routes
  }
}

public enum NewsCardCoordinatorAction: IndexedRouterAction {
  case updateRoutes([Route<NewsCardScreenState>])
  case routeAction(Int, action: NewsCardScreenAction)
}

public struct NewsCardCoordinatorEnvironment {
  fileprivate let newsCardService: NewsCardService
  
  public init(newsCardService: NewsCardService) {
    self.newsCardService = newsCardService
  }
}

public let newsCardCoordinatorReducer: Reducer<
  NewsCardCoordinatorState,
  NewsCardCoordinatorAction,
  NewsCardCoordinatorEnvironment
> = newsCardScreenReducer
  .forEachIndexedRoute(environment: {
    NewsCardScreenEnvironment(newsCardService: $0.newsCardService)
  })
  .withRouteReducer(
    Reducer { state, action, env in
      switch action {        
      case let .routeAction(_, action: .newsList(._willDisappear(totalShortsCount))):
        state.routes.push(.shortsComplete(.init(totalShortsCount: totalShortsCount)))
        return .none

      default: return .none
      }
    }
  )

//
//  NewsCardCoordinatorCore.swift
//  Coordinator
//
//  Created by GREEN on 2023/04/28.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import ComposableArchitecture
import Services
import SwiftUI
import TCACoordinators

public struct NewsCardCoordinatorState: Equatable, IndexedRouterState {
  public var routes: [Route<NewsCardScreenState>]
  
  public init(
    routes: [Route<NewsCardScreenState>] = [
      .root(
        .newsList(.init()),
        embedInNavigationView: false
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
}

public let newsCardCoordinatorReducer: Reducer<
  NewsCardCoordinatorState,
  NewsCardCoordinatorAction,
  NewsCardCoordinatorEnvironment
> = newsCardScreenReducer
  .forEachIndexedRoute(environment: { _ in
    NewsCardScreenEnvironment()
  })
  .withRouteReducer(
    Reducer { state, action, env in
      switch action {
      default: return .none
      }
    }
  )


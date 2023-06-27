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
          .init(keywordTitle: "하하호호 키워드 이름")
        ),
        embedInNavigationView: true
      )
    ]
  ) {
    self.routes = routes
  }
}

public enum NewsCardCoordinatorAction: Equatable, IndexedRouterAction {
  case updateRoutes([Route<NewsCardScreenState>])
  case routeAction(Int, action: NewsCardScreenAction)
}

public struct NewsCardCoordinatorEnvironment {
  public init() {}
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
      case .routeAction(_, action: .newsList(.newsItem(id: _, action: .rightButtonTapped))):
        state.routes.push(.web(.init(webAddress: "https://naver.com")))
        return .none
        
      case .routeAction(_, action: .newsList(.newsItem(id: _, action: .cardTapped))):
        state.routes.push(.web(.init(webAddress: "https://naver.com")))
        return .none
        
      case .routeAction(_, action: .newsList(._willDisappear)):
        state.routes.push(.shortsComplete(.init()))
        return .none
        
      case .routeAction(_, action: .web(.backButtonTapped)):
        state.routes.pop()
        return .none

      default: return .none
      }
    }
  )

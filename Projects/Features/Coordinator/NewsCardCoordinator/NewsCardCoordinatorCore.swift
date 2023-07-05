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
    source: SourceType,
    shortsId: Int,
    keywordTitle: String
  ) {
    self.routes = [
      .root(
        .newsList(
          .init(
            source: source,
            shortsId: shortsId,
            keywordTitle: keywordTitle
          )
        ),
        embedInNavigationView: true
      )
    ]
  }
  
  public init(webAddress: String) {
    self.routes = [.root(.web(.init(newsId: 0, webAddress: webAddress)))]
  }
}

public enum NewsCardCoordinatorAction: IndexedRouterAction {
  case updateRoutes([Route<NewsCardScreenState>])
  case routeAction(Int, action: NewsCardScreenAction)
}

public struct NewsCardCoordinatorEnvironment {
  fileprivate let mainQueue: AnySchedulerOf<DispatchQueue>
  fileprivate let newsCardService: NewsCardService
  
  public init(
    mainQueue: AnySchedulerOf<DispatchQueue>,
    newsCardService: NewsCardService
  ) {
    self.mainQueue = mainQueue
    self.newsCardService = newsCardService
  }
}

public let newsCardCoordinatorReducer: Reducer<
  NewsCardCoordinatorState,
  NewsCardCoordinatorAction,
  NewsCardCoordinatorEnvironment
> = newsCardScreenReducer
  .forEachIndexedRoute(environment: {
    NewsCardScreenEnvironment(
      mainQueue: $0.mainQueue,
      newsCardService: $0.newsCardService
    )
  })
  .withRouteReducer(
    Reducer { state, action, env in
      switch action {        
      case let .routeAction(_, action: .newsList(._willDisappear(totalShortsCount))):
        state.routes.push(.shortsComplete(.init(totalShortsCount: totalShortsCount)))
        return .none
        
      case let .routeAction(_, action: .newsList(.newsItem(id: id, action: ._navigateWebView(url)))):
        state.routes.push(.web(.init(newsId: id, webAddress: url)))
        return .none
        
      default: return .none
      }
    }
  )

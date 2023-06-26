//
//  LongStorageCoordinatorCore.swift
//  Coordinator
//
//  Created by GREEN on 2023/04/28.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import ComposableArchitecture
import LongStorageNewsList
import Services
import SwiftUI
import TCACoordinators

public struct LongStorageCoordinatorState: Equatable, IndexedRouterState {
  public var routes: [Route<LongStorageScreenState>]
  
  public init(
    routes: [Route<LongStorageScreenState>] = [
      .root(
        .longStorageNewsList(
          .init(
            isInEditMode: false,
            shortslistCount: 6,
            shortsClearCount: 3
          )
        ),
        embedInNavigationView: true
      )
    ]
  ) {
    self.routes = routes
  }
}

public enum LongStorageCoordinatorAction: IndexedRouterAction {
  case updateRoutes([Route<LongStorageScreenState>])
  case routeAction(Int, action: LongStorageScreenAction)
}

public struct LongStorageCoordinatorEnvironment {
  public init() {}
}

public let longStorageCoordinatorReducer: Reducer<
  LongStorageCoordinatorState,
  LongStorageCoordinatorAction,
  LongStorageCoordinatorEnvironment
> = longStorageScreenReducer
  .forEachIndexedRoute(environment: { _ in
    LongStorageScreenEnvironment()
  })
  .withRouteReducer(
    Reducer { state, action, env in
      switch action {
      case .routeAction(
        _,
        action: .longStorageNewsList(
          .shortsNewsItem(
            id: _,
            action: .cardAction(
              .rightButtonTapped
            )
          )
        )
      ):
        state.routes.push(.web(.init(webAddress: "https://naver.com")))
        return .none
        
      case .routeAction(_, action: .longStorageNewsList(.shortsNewsItem(id: _, action: .cardAction(.cardTapped)))):
        state.routes.push(.web(.init(webAddress: "https://naver.com")))
        return .none

      case .routeAction(_, action: .web(.backButtonTapped)):
        state.routes.pop()
        return .none
        
      default: return .none
      }
    }
  )

//
//  LongStorageCoordinatorCore.swift
//  Coordinator
//
//  Created by GREEN on 2023/04/28.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import ComposableArchitecture
import Services
import SwiftUI
import TCACoordinators

public struct LongStorageCoordinatorState: Equatable, IndexedRouterState {
  public var routes: [Route<LongStorageScreenState>]
  
  public init(
    routes: [Route<LongStorageScreenState>] = [
      .root(
        .longStorageNewsList(.init()),
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
      default: return .none
      }
    }
  )


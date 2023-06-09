//
//  MainCoordinatorCore.swift
//  MainCoordinator
//
//  Created by 안상희 on 2023/05/21.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Combine
import ComposableArchitecture
import Main
import TCACoordinators

public struct MainCoordinatorState: Equatable, IndexedRouterState {
  public var routes: [Route<MainScreenState>]
  
  public init(
    routes: [Route<MainScreenState>] = [
      .root(
        .main(.init()),
        embedInNavigationView: true
      )
    ]
  ) {
    self.routes = routes
  }
}

public enum MainCoordinatorAction: IndexedRouterAction {
  case updateRoutes([Route<MainScreenState>])
  case routeAction(Int, action: MainScreenAction)
}

public struct MainCoordinatorEnvironment {
  public init() {}
}

public let mainCoordinatorReducer: Reducer<
  MainCoordinatorState,
  MainCoordinatorAction,
  MainCoordinatorEnvironment
> = mainScreenReducer
  .forEachIndexedRoute(
    environment: { _ in
      MainScreenEnvironment()
    }
  )
  .withRouteReducer(
    Reducer { state, action, env in
      switch action {
      default: return .none
      }
    }
  )

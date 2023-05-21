//
//  TabBarCoordinatorCore.swift
//  Coordinator
//
//  Created by 안상희 on 2023/05/21.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Combine
import ComposableArchitecture
import TCACoordinators

public struct TabBarCoordinatorState: Equatable, IndexedRouterState {
  public var routes: [Route<TabBarScreenState>]
  
  public init(routes: [Route<TabBarScreenState>] = [.root(.hotKeyword(.init()), embedInNavigationView: true)]) {
    self.routes = routes
  }
}

public enum TabBarCoordinatorAction: IndexedRouterAction {
  case updateRoutes([Route<TabBarScreenState>])
  case routeAction(Int, action: TabBarScreenAction)
}

public struct TabBarCoordinatorEnvironment {
  public init() { }
}

public let tabBarCoordinatorReducer: Reducer<
  TabBarCoordinatorState,
  TabBarCoordinatorAction,
  TabBarCoordinatorEnvironment
> = tabBarScreenReducer
  .forEachIndexedRoute(
    environment: { _ in
      TabBarScreenEnvironment()
    }
  )
  .withRouteReducer(
    Reducer { state, action, env in
      switch action {
      default: return .none
      }
    }
  )

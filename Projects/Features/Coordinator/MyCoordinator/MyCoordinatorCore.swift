//
//  MyCoordinatorCore.swift
//  MyCoordinator
//
//  Created by 안상희 on 2023/05/22.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Combine
import ComposableArchitecture
import ShortStorageCoordinator
import TCACoordinators

public struct MyCoordinatorState: Equatable, IndexedRouterState {
  public var routes: [Route<MyScreenState>]
  
  public init(routes: [Route<MyScreenState>] = [.root(.shortStorage(.init()), embedInNavigationView: true)]) {
    self.routes = routes
  }
}

public enum MyCoordinatorAction: IndexedRouterAction {
  case updateRoutes([Route<MyScreenState>])
  case routeAction(Int, action: MyScreenAction)
}

public struct MyCoordinatorEnvironment {
  public init() {}
}

public let myCoordinatorReducer: Reducer<
  MyCoordinatorState,
  MyCoordinatorAction,
  MyCoordinatorEnvironment
> = myScreenReducer
  .forEachIndexedRoute(
    environment: { _ in
      MyScreenEnvironment()
    }
  )
  .withRouteReducer(
    Reducer { state, action, env in
      switch action {
      default: return .none
      }
    }
  )

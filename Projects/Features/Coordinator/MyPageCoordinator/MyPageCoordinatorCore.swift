//
//  MyPageCoordinatorCore.swift
//  MyPageCoordinator
//
//  Created by 안상희 on 2023/05/22.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Combine
import ComposableArchitecture
import ShortStorageCoordinator
import TCACoordinators

public struct MyPageCoordinatorState: Equatable, IndexedRouterState {
  public var routes: [Route<MyPageScreenState>]
  
  public init(routes: [Route<MyPageScreenState>] = [.root(.shortStorage(.init()), embedInNavigationView: true)]) {
    self.routes = routes
  }
}

public enum MyPageCoordinatorAction: IndexedRouterAction {
  case updateRoutes([Route<MyPageScreenState>])
  case routeAction(Int, action: MyPageScreenAction)
}

public struct MyPageCoordinatorEnvironment {
  public init() {}
}

public let myPageCoordinatorReducer: Reducer<
  MyPageCoordinatorState,
  MyPageCoordinatorAction,
  MyPageCoordinatorEnvironment
> = myPageScreenReducer
  .forEachIndexedRoute(
    environment: { _ in
      MyPageScreenEnvironment()
    }
  )
  .withRouteReducer(
    Reducer { state, action, env in
      switch action {
      default: return .none
      }
    }
  )
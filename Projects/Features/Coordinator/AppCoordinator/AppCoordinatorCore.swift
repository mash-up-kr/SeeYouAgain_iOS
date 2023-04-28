//
//  AppCoordinatorCore.swift
//  CoordinatorKit
//
//  Created by GREEN on 2023/04/28.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Combine
import ComposableArchitecture
import Foundation
import TCACoordinators

public struct AppCoordinatorState: Equatable, IndexedRouterState {
  public var routes: [Route<AppScreenState>]

  public init(routes: [Route<TestScreenState>] = [.root(.splash(.init()), embedInNavigationView: true)]) {
    self.routes = routes
  }
}

public enum AppCoordinatorAction: IndexedRouterAction {
  case updateRoutes([Route<AppScreenState>])
  case routeAction(Int, action: AppScreenAction)
}

public struct AppCoordinatorEnvironment {
  public init() {
  }
}

public let appCoordinatorReducer: Reducer<
  AppCoordinatorState,
  AppCoordinatorAction,
  AppCoordinatorEnvironment
> = testScreenReducer
  .forEachIndexedRoute(
    environment: { _ in
      AppScreenEnvironment()
    }
  )
  .withRouteReducer(
    Reducer { state, action, env in
      switch action {
      default: return .none
      }
    }
  )

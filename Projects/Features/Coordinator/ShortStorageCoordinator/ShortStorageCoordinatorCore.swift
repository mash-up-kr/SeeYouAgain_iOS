//
//  ShortStorageCoordinatorCore.swift
//  Coordinator
//
//  Created by GREEN on 2023/04/28.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import ComposableArchitecture
import Services
import SwiftUI
import TCACoordinators

public struct ShortStorageCoordinatorState: Equatable, IndexedRouterState {
  public var routes: [Route<ShortStorageScreenState>]
  
  public init(
    routes: [Route<ShortStorageScreenState>] = [
      .root(
        .shortStorageCardList(.init()),
        embedInNavigationView: true
      )
    ]
  ) {
    self.routes = routes
  }
}

public enum ShortStorageCoordinatorAction: IndexedRouterAction, Equatable {
  case updateRoutes([Route<ShortStorageScreenState>])
  case routeAction(Int, action: ShortStorageScreenAction)
}

public struct ShortStorageCoordinatorEnvironment {
}

public let shortStorageCoordinatorReducer: Reducer<
  ShortStorageCoordinatorState,
  ShortStorageCoordinatorAction,
  ShortStorageCoordinatorEnvironment
> = settingScreenReducer
  .forEachIndexedRoute(environment: { _ in
    ShortStorageScreenEnvironment()
  })
  .withRouteReducer(
    Reducer { state, action, env in
      switch action {
      default: return .none
      }
    }
  )


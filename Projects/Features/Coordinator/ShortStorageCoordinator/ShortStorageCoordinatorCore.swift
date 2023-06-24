//
//  ShortStorageCoordinatorCore.swift
//  Coordinator
//
//  Created by GREEN on 2023/04/28.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import ComposableArchitecture
import Foundation
import Services
import ShortStorageNewsList
import TCACoordinators

public struct ShortStorageCoordinatorState: Equatable, IndexedRouterState {
  public var routes: [Route<ShortStorageScreenState>]
  
  public init(
    routes: [Route<ShortStorageScreenState>] = [
      .root(
        .shortStorageNewsList(
          .init(
            isInEditMode: false,
            shortslistCount: 6,
            shortsClearCount: 0
          )
        ),
        embedInNavigationView: true
      )
    ]
  ) {
    self.routes = routes
  }
}

public enum ShortStorageCoordinatorAction: IndexedRouterAction {
  case updateRoutes([Route<ShortStorageScreenState>])
  case routeAction(Int, action: ShortStorageScreenAction)
}

public struct ShortStorageCoordinatorEnvironment {
  let mainQueue: AnySchedulerOf<DispatchQueue>
  
  public init(
    mainQueue: AnySchedulerOf<DispatchQueue>
  ) {
    self.mainQueue = mainQueue
  }
}

public let shortStorageCoordinatorReducer: Reducer<
  ShortStorageCoordinatorState,
  ShortStorageCoordinatorAction,
  ShortStorageCoordinatorEnvironment
> = shortStorageScreenReducer
  .forEachIndexedRoute(environment: {
    ShortStorageScreenEnvironment(mainQueue: $0.mainQueue)
  })
  .withRouteReducer(
    Reducer { state, action, env in
      switch action {
      default: return .none
      }
    }
  )

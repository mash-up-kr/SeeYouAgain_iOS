//
//  MainCoordinatorCore.swift
//  MainCoordinator
//
//  Created by GREEN on 2023/04/05.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import ComposableArchitecture
import Services
import SwiftUI
import TCACoordinators

public struct MainCoordinatorState: Equatable, IndexedRouterState {
  public var routes: [Route<MainScreenState>]
  
  public init(
    routes: [Route<MainScreenState>] = [
      .root(
        .home(.init()),
        embedInNavigationView: true
      )
    ]
  ) {
    self.routes = routes
  }
  
  public static func == (lhs: MainCoordinatorState, rhs: MainCoordinatorState) -> Bool {
    lhs.routes == rhs.routes
  }
}

public enum MainCoordinatorAction: IndexedRouterAction, Equatable {
  case updateRoutes([Route<MainScreenState>])
  case routeAction(Int, action: MainScreenAction)
}

public struct MainCoordinatorEnvironment {
  var userService: UserService
  
  public init(userService: UserService) {
    self.userService = userService
  }
}

public let mainCoordinatorReducer: Reducer<
  MainCoordinatorState,
  MainCoordinatorAction,
  MainCoordinatorEnvironment
> = mainScreenReducer
  .forEachIndexedRoute(environment: {
    MainScreenEnvironment(userService: $0.userService)
  })
  .withRouteReducer(
    Reducer { state, action, env in
      switch action {
      case .routeAction(_, action: .home(.moveToSettingButtonTapped)):
        state.routes.push(.setting(.init()))
        return .none
        
      case .routeAction(_, action: .setting(.backButtonTapped)):
        state.routes.pop()
        return .none
        
      default: return .none
      }
    }
  )

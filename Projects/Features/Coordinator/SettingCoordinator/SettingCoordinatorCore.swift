//
//  SettingCoordinatorCore.swift
//  Coordinator
//
//  Created by GREEN on 2023/04/28.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import ComposableArchitecture
import Services
import Setting
import SwiftUI
import TCACoordinators

public struct SettingCoordinatorState: Equatable, IndexedRouterState {
  public var routes: [Route<SettingScreenState>]
  
  public init(
    routes: [Route<SettingScreenState>] = [
      .root(
        .setting(.init()),
        embedInNavigationView: true
      )
    ]
  ) {
    self.routes = routes
  }
}

public enum SettingCoordinatorAction: IndexedRouterAction {
  case updateRoutes([Route<SettingScreenState>])
  case routeAction(Int, action: SettingScreenAction)
}

public struct SettingCoordinatorEnvironment {
  public init() {}
}

public let settingCoordinatorReducer: Reducer<
  SettingCoordinatorState,
  SettingCoordinatorAction,
  SettingCoordinatorEnvironment
> = settingScreenReducer
  .forEachIndexedRoute(environment: { _ in
    SettingScreenEnvironment()
  })
  .withRouteReducer(
    Reducer { state, action, env in
      switch action {
      default: return .none
      }
    }
  )

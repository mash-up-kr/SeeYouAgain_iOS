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
  let appVersionService: AppVersionService
  
  public init(appVersionService: AppVersionService) {
    self.appVersionService = appVersionService
  }
}

public let settingCoordinatorReducer: Reducer<
  SettingCoordinatorState,
  SettingCoordinatorAction,
  SettingCoordinatorEnvironment
> = settingScreenReducer
  .forEachIndexedRoute(environment: {
    SettingScreenEnvironment(appVersionService: $0.appVersionService)
  })
  .withRouteReducer(
    Reducer { state, action, env in
      switch action {
      // 설정 뷰 -> 앱 버전 뷰
      case .routeAction(_, action: .setting(.navigateAppVersion)):
        state.routes.push(.appVersion(.init()))
        return .none
        
      // 앱 버전 뷰 -> 설정 뷰
      case .routeAction(_, action: .appVersion(.backButtonTapped)):
        state.routes.goBack()
        return .none
        
      default: return .none
      }
    }
  )

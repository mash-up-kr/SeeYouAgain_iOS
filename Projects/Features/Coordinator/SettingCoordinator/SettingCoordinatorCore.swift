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
  
  public init(nickname: String) {
    self.routes = [.root(.setting(.init(nickname: nickname)), embedInNavigationView: true)]
  }
}

public enum SettingCoordinatorAction: IndexedRouterAction {
  case updateRoutes([Route<SettingScreenState>])
  case routeAction(Int, action: SettingScreenAction)
}

public struct SettingCoordinatorEnvironment {
  let appVersionService: AppVersionService
  let userDefaultsService: UserDefaultsService
  
  public init(
    appVersionService: AppVersionService,
    userDefaultsService: UserDefaultsService
  ) {
    self.appVersionService = appVersionService
    self.userDefaultsService = userDefaultsService
  }
}

public let settingCoordinatorReducer: Reducer<
  SettingCoordinatorState,
  SettingCoordinatorAction,
  SettingCoordinatorEnvironment
> = settingScreenReducer
  .forEachIndexedRoute(environment: {
    SettingScreenEnvironment(
      appVersionService: $0.appVersionService,
      userDefaultsService: $0.userDefaultsService
    )
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
        
      // 설정 뷰 -> 모드 선택 뷰
      case .routeAction(_, action: .setting(.navigateModeSelection)):
        state.routes.push(.modeSelection(.init()))
        return .none
      
      // 모드 선택 뷰 -> 설정 뷰
      case .routeAction(_, action: .modeSelection(.backButtonTapped)):
        state.routes.goBack()
        return .none
        
      // 모드 선택 뷰 -> 관심 기업 선택 뷰
      case .routeAction(_, action: .modeSelection(.navigateCompanySelection)):
        state.routes.push(.companySelection(.init()))
        return .none
        
      // 관심 기업 선택 뷰 -> 모드 선택 뷰
      case .routeAction(_, action: .companySelection(.backButtonTapped)):
        state.routes.goBack()
        return .none
      
      default: return .none
      }
    }
  )

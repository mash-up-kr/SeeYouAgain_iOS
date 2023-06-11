//
//  AppCoordinatorCore.swift
//  CoordinatorKit
//
//  Created by GREEN on 2023/04/28.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Combine
import ComposableArchitecture
import Services
import Splash
import TCACoordinators

public struct AppCoordinatorState: Equatable, IndexedRouterState {
  public var routes: [Route<AppScreenState>]
  
  public init(routes: [Route<AppScreenState>] = [.root(.splash(.init()), embedInNavigationView: true)]) {
    self.routes = routes
  }
}

public enum AppCoordinatorAction: IndexedRouterAction {
  case updateRoutes([Route<AppScreenState>])
  case routeAction(Int, action: AppScreenAction)
}

public struct AppCoordinatorEnvironment {
  var userDefaultsService: UserDefaultsService
  
  public init(userDefaultsService: UserDefaultsService) {
    self.userDefaultsService = userDefaultsService
  }
}

public let appCoordinatorReducer: Reducer<
  AppCoordinatorState,
  AppCoordinatorAction,
  AppCoordinatorEnvironment
> = appScreenReducer
  .forEachIndexedRoute(
    environment: {
      AppScreenEnvironment(userDefaultsService: $0.userDefaultsService)
    }
  )
  .withRouteReducer(
    Reducer { state, action, env in
      switch action {
      case .routeAction(_, action: .splash(.viewDidLoad)):
        state.routes = [
          .root(
            .tabBar(
              .init(
                hotKeyword: .init(),
                main: .init(),
                myPage: .init(),
                categoryBottomSheet: .init()
              )
            ),
            embedInNavigationView: true
          )
        ]
        return .none
        
      case .routeAction(_, action: .splash(._setCategoryViewLoad)):
        state.routes = [
          .root(
            .setCategory(.init()),
            embedInNavigationView: true
          )
        ]
        return .none
        
      case .routeAction(_, action: .setCategory(._sendSelectedCategory)):
        state.routes = [
          .root(
            .tabBar(
              .init(
                hotKeyword: .init(),
                main: .init(),
                myPage: .init(),
                categoryBottomSheet: .init()
              )
            ),
            embedInNavigationView: true
          )
        ]
        return .none
        
      default: return .none
      }
    }
  )

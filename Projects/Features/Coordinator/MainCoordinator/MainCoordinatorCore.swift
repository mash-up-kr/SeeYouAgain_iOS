//
//  MainCoordinatorCore.swift
//  MainCoordinator
//
//  Created by 안상희 on 2023/05/21.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Combine
import ComposableArchitecture
import Foundation
import Main
import Services
import TCACoordinators

public struct MainCoordinatorState: Equatable, IndexedRouterState {
  public var routes: [Route<MainScreenState>]
  
  public init(
    routes: [Route<MainScreenState>] = [
      .root(
        .main(.init()),
        embedInNavigationView: true
      )
    ]
  ) {
    self.routes = routes
  }
}

public enum MainCoordinatorAction: IndexedRouterAction {
  case updateRoutes([Route<MainScreenState>])
  case routeAction(Int, action: MainScreenAction)
}

public struct MainCoordinatorEnvironment {
  fileprivate let mainQueue: AnySchedulerOf<DispatchQueue>
  fileprivate let userDefaultsService: UserDefaultsService
  fileprivate let newsCardService: NewsCardService
  fileprivate let categoryService: CategoryService
  
  public init(
    mainQueue: AnySchedulerOf<DispatchQueue>,
    userDefaultsService: UserDefaultsService,
    newsCardService: NewsCardService,
    categoryService: CategoryService
  ) {
    self.mainQueue = mainQueue
    self.userDefaultsService = userDefaultsService
    self.newsCardService = newsCardService
    self.categoryService = categoryService
  }
}

public let mainCoordinatorReducer: Reducer<
  MainCoordinatorState,
  MainCoordinatorAction,
  MainCoordinatorEnvironment
> = mainScreenReducer
  .forEachIndexedRoute(
    environment: {
      MainScreenEnvironment(
        mainQueue: $0.mainQueue,
        userDefaultsService: $0.userDefaultsService,
        newsCardService: $0.newsCardService,
        categoryService: $0.categoryService
      )
    }
  )
  .withRouteReducer(
    Reducer { state, action, env in
      switch action {
      default: return .none
      }
    }
  )

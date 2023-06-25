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
  let mainQueue: AnySchedulerOf<DispatchQueue>
  let userDefaultsService: UserDefaultsService
  let appVersionService: AppVersionService
  let newsCardService: NewsCardService  
  let categoryService: CategoryService
  
  public init(
    mainQueue: AnySchedulerOf<DispatchQueue>,
    userDefaultsService: UserDefaultsService,
    appVersionService: AppVersionService,
    newsCardService: NewsCardService,
    categoryService: CategoryService
  ) {
    self.mainQueue = mainQueue
    self.userDefaultsService = userDefaultsService
    self.appVersionService = appVersionService
    self.newsCardService = newsCardService
    self.categoryService = categoryService
  }
}

public let appCoordinatorReducer: Reducer<
  AppCoordinatorState,
  AppCoordinatorAction,
  AppCoordinatorEnvironment
> = appScreenReducer
  .forEachIndexedRoute(
    environment: {
      AppScreenEnvironment(
        mainQueue: $0.mainQueue,
        userDefaultsService: $0.userDefaultsService,
        appVersionService: $0.appVersionService,
        newsCardService: $0.newsCardService,
        categoryService: $0.categoryService
      )
    }
  )
  .withRouteReducer(
    Reducer { state, action, env in
      switch action {
      case .routeAction(_, action: .splash(._moveToHome)):
        state.routes = [
          .root(
            .tabBar(
              .init(
                hotKeyword: .init(),
                main: .init(),
                myPage: .init(),
                categoryBottomSheet: .init(),
                isTabHidden: false
              )
            ),
            embedInNavigationView: true
          )
        ]
        return .none
        
      case .routeAction(_, action: .splash(._moveToSetCategory)):
        state.routes = [
          .root(
            .setCategory(.init()),
            embedInNavigationView: true
          )
        ]
        return .none
        
      case .routeAction(_, action: .setCategory(._saveUserID)):
        state.routes = [
          .root(
            .tabBar(
              .init(
                hotKeyword: .init(),
                main: .init(),
                myPage: .init(),
                categoryBottomSheet: .init(),
                isTabHidden: false
              )
            ),
            embedInNavigationView: true
          )
        ]
        return .none
        
      case let .routeAction(
        _,
        action: .tabBar(
          .myPage(
            .routeAction(
              _,
              action: .shortStorage(
                .routeAction(
                  _,
                  action: .shortStorageNewsList(
                    .shortsNewsItem(
                      id: id,
                      action: .cardAction(.rightButtonTapped)
                    )
                  )
                )
              )
            )
          )
        )
      ):
        state.routes.push(.newsCard(.init()))
        return .none
        
      case let .routeAction(
        _,
        action: .tabBar(
          .myPage(
            .routeAction(
              _,
              action: .shortStorage(
                .routeAction(
                  _,
                  action: .shortStorageNewsList(
                    .shortsNewsItem(
                      id: id,
                      action: .cardAction(.cardTapped)
                    )
                  )
                )
              )
            )
          )
        )
      ):
        state.routes.push(.newsCard(.init()))
        return .none
        
      case .routeAction(_, action: .newsCard(.routeAction(_, action: .shortsComplete(.backButtonTapped)))):
        state.routes.pop()
        return .none
        
      case .routeAction(_, action: .newsCard(.routeAction(_, action: .shortsComplete(.completeButtonTapped)))):
        state.routes.pop()
        return .none
        
      case .routeAction(_, action: .newsCard(.routeAction(_, action: .newsList(.backButtonTapped)))):
        state.routes.pop()
        return .none
        
      default: return .none
      }
    }
  )

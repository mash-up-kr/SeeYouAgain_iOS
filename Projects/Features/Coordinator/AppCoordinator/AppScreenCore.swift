//
//  AppScreenCore.swift
//  CoordinatorKit
//
//  Created by GREEN on 2023/04/28.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Combine
import ComposableArchitecture
import Foundation
import NewsCardCoordinator
import Services
import SetCategory
import SettingCoordinator
import Splash
import TabBar
import TCACoordinators

public enum AppScreenState: Equatable {
  case splash(SplashState)
  case setCategory(SetCategoryState)
  case tabBar(TabBarState)
  case newsCard(NewsCardCoordinatorState)
  case setting(SettingCoordinatorState)
}

public enum AppScreenAction {
  case splash(SplashAction)
  case setCategory(SetCategoryAction)
  case tabBar(TabBarAction)
  case newsCard(NewsCardCoordinatorAction)
  case setting(SettingCoordinatorAction)
}

internal struct AppScreenEnvironment {
  let mainQueue: AnySchedulerOf<DispatchQueue>
  let userDefaultsService: UserDefaultsService
  
  internal init(
    mainQueue: AnySchedulerOf<DispatchQueue>,
    userDefaultsService: UserDefaultsService
  ) {
    self.mainQueue = mainQueue
    self.userDefaultsService = userDefaultsService
  }
}

internal let appScreenReducer = Reducer<
  AppScreenState,
  AppScreenAction,
  AppScreenEnvironment
>.combine([
  splashReducer
    .pullback(
      state: /AppScreenState.splash,
      action: /AppScreenAction.splash,
      environment: {
        SplashEnvironment(userDefaultsService: $0.userDefaultsService)
      }
    ),
  setCategoryReducer
    .pullback(
      state: /AppScreenState.setCategory,
      action: /AppScreenAction.setCategory,
      environment: {
        SetCategoryEnvironment(
          mainQueue: $0.mainQueue,
          userDefaultsService: $0.userDefaultsService
        )
      }
    ),
  tabBarReducer
    .pullback(
      state: /AppScreenState.tabBar,
      action: /AppScreenAction.tabBar,
      environment: { _ in
        TabBarEnvironment()
      }
    ),
  newsCardCoordinatorReducer
    .pullback(
      state: /AppScreenState.newsCard,
      action: /AppScreenAction.newsCard,
      environment: { _ in
        NewsCardCoordinatorEnvironment()
      }
    ),
  settingCoordinatorReducer
    .pullback(
      state: /AppScreenState.setting,
      action: /AppScreenAction.setting,
      environment: { _ in
        SettingCoordinatorEnvironment()
      }
    ),
])

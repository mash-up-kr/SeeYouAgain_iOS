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
  let appVersionService: AppVersionService
  let newsCardService: NewsCardService
  let categoryService: CategoryService
  let hotKeywordService: HotKeywordService
  let myPageService: MyPageService
  let logService: LogService
  
  internal init(
    mainQueue: AnySchedulerOf<DispatchQueue>,
    userDefaultsService: UserDefaultsService,
    appVersionService: AppVersionService,
    newsCardService: NewsCardService,
    categoryService: CategoryService,
    hotKeywordService: HotKeywordService,
    myPageService: MyPageService,
    logService: LogService
  ) {
    self.mainQueue = mainQueue
    self.userDefaultsService = userDefaultsService
    self.appVersionService = appVersionService
    self.newsCardService = newsCardService
    self.categoryService = categoryService
    self.hotKeywordService = hotKeywordService
    self.myPageService = myPageService
    self.logService = logService
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
        SplashEnvironment(
          userDefaultsService: $0.userDefaultsService,
          logService: $0.logService
        )
      }
    ),
  setCategoryReducer
    .pullback(
      state: /AppScreenState.setCategory,
      action: /AppScreenAction.setCategory,
      environment: {
        SetCategoryEnvironment(
          mainQueue: $0.mainQueue,
          userDefaultsService: $0.userDefaultsService,
          categoryService: $0.categoryService
        )
      }
    ),
  tabBarReducer
    .pullback(
      state: /AppScreenState.tabBar,
      action: /AppScreenAction.tabBar,
      environment: {
        TabBarEnvironment(
          mainQueue: $0.mainQueue,
          userDefaultsService: $0.userDefaultsService,
          appVersionService: $0.appVersionService,
          newsCardService: $0.newsCardService,
          categoryService: $0.categoryService,
          hotKeywordService: $0.hotKeywordService,
          myPageService: $0.myPageService
        )
      }
    ),
  newsCardCoordinatorReducer
    .pullback(
      state: /AppScreenState.newsCard,
      action: /AppScreenAction.newsCard,
      environment: {
        NewsCardCoordinatorEnvironment(
          mainQueue: $0.mainQueue,
          newsCardService: $0.newsCardService
        )
      }
    ),
  settingCoordinatorReducer
    .pullback(
      state: /AppScreenState.setting,
      action: /AppScreenAction.setting,
      environment: {
        SettingCoordinatorEnvironment(
          appVersionService: $0.appVersionService,
          userDefaultsService: $0.userDefaultsService
        )
      }
    )
])

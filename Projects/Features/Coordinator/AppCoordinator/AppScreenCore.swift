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
import HotKeywordCoordinator
import LongStorageCoordinator
import Main
import NewsCardCoordinator
import SetCategory
import SettingCoordinator
import ShortStorageCoordinator
import Splash
import TCACoordinators

public enum AppScreenState: Equatable {
  case splash(SplashState)
  case setCategory(SetCategoryState)
  case main(MainState)
  case hotKeyword(HotKeywordCoordinatorState)
  case shortStorage(ShortStorageCoordinatorState)
  case longStorage(LongStorageCoordinatorState)
  case newsCard(NewsCardCoordinatorState)
  case setting(SettingCoordinatorState)
}

public enum AppScreenAction {
  case splash(SplashAction)
  case setCategory(SetCategoryAction)
  case main(MainAction)
  case hotKeyword(HotKeywordCoordinatorAction)
  case shortStorage(ShortStorageCoordinatorAction)
  case longStorage(LongStorageCoordinatorAction)
  case newsCard(NewsCardCoordinatorAction)
  case setting(SettingCoordinatorAction)
}

internal struct AppScreenEnvironment {
  internal init() {
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
      environment: { _ in
        SplashEnvironment()
      }
    ),
  setCategoryReducer
    .pullback(
      state: /AppScreenState.setCategory,
      action: /AppScreenAction.setCategory,
      environment: { _ in
        SetCategoryEnvironment()
      }
    ),
  mainReducer
    .pullback(
      state: /AppScreenState.main,
      action: /AppScreenAction.main,
      environment: { _ in
        MainEnvironment()
      }
    ),
  hotKeywordCoordinatorReducer
    .pullback(
      state: /AppScreenState.hotKeyword,
      action: /AppScreenAction.hotKeyword,
      environment: { _ in
        HotKeywordCoordinatorEnvironment()
      }
    ),
  shortStorageCoordinatorReducer
    .pullback(
      state: /AppScreenState.shortStorage,
      action: /AppScreenAction.shortStorage,
      environment: { _ in
        ShortStorageCoordinatorEnvironment()
      }
    ),
  longStorageCoordinatorReducer
    .pullback(
      state: /AppScreenState.longStorage,
      action: /AppScreenAction.longStorage,
      environment: { _ in
        LongStorageCoordinatorEnvironment()
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

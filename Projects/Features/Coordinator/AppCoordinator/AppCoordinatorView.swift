//
//  AppCoordinatorView.swift
//  Coordinator
//
//  Created by GREEN on 2023/04/28.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Combine
import ComposableArchitecture
import Main
import Splash
import SetCategory
import HotKeywordCoordinator
import ShortStorageCoordinator
import LongStorageCoordinator
import NewsCardCoordinator
import SettingCoordinator
import SwiftUI
import TCACoordinators

public struct AppCoordinatorView: View {
  private let store: Store<AppCoordinatorState, AppCoordinatorAction>
  
  public init(store: Store<AppCoordinatorState, AppCoordinatorAction>) {
    self.store = store
  }

  public var body: some View {
    TCARouter(store) { screen in
      SwitchStore(screen) {
        CaseLet(
          state: /AppScreenState.splash,
          action: AppScreenAction.splash,
          then: SplashView.init
        )
        CaseLet(
          state: /AppScreenState.setCategory,
          action: AppScreenAction.setCategory,
          then: SetCategoryView.init
        )
        CaseLet(
          state: /AppScreenState.main,
          action: AppScreenAction.main,
          then: MainView.init
        )
        CaseLet(
          state: /AppScreenState.hotKeyword,
          action: AppScreenAction.hotKeyword,
          then: HotKeywordCoordinatorView.init
        )
        CaseLet(
          state: /AppScreenState.shortStorage,
          action: AppScreenAction.shortStorage,
          then: ShortStorageCoordinatorView.init
        )
        CaseLet(
          state: /AppScreenState.longStorage,
          action: AppScreenAction.longStorage,
          then: LongStorageCoordinatorView.init
        )
        CaseLet(
          state: /AppScreenState.newsCard,
          action: AppScreenAction.newsCard,
          then: NewsCardCoordinatorView.init
        )
        CaseLet(
          state: /AppScreenState.setting,
          action: AppScreenAction.setting,
          then: SettingCoordinatorView.init
        )
      }
    }
  }
}

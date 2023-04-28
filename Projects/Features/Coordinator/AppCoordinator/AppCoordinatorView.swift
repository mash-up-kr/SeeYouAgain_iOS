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
          state: /AppCoordinatorState.splash,
          action: AppCoordinatorAction.splash,
          then: SplashView.init
        )
        CaseLet(
          state: /AppCoordinatorState.setCategory,
          action: AppCoordinatorAction.setCategory,
          then: SetCategoryView.init
        )
        CaseLet(
          state: /AppCoordinatorState.main,
          action: AppCoordinatorAction.main,
          then: MainView.init
        )
        CaseLet(
          state: /AppCoordinatorState.hotKeyword,
          action: AppCoordinatorAction.hotKeyword,
          then: HotKeywordCoordinatorView.init
        )
        CaseLet(
          state: /AppCoordinatorState.shortStorage,
          action: AppCoordinatorAction.shortStorage,
          then: ShortStorageCoordinatorView.init
        )
        CaseLet(
          state: /AppCoordinatorState.longStorage,
          action: AppCoordinatorAction.longStorage,
          then: LongStorageCoordinatorView.init
        )
        CaseLet(
          state: /AppCoordinatorState.newsCard,
          action: AppCoordinatorAction.newsCard,
          then: NewsCardCoordinatorView.init
        )
        CaseLet(
          state: /AppCoordinatorState.setting,
          action: AppCoordinatorAction.setting,
          then: SettingCoordinatorView.init
        )
      }
    }
  }
}

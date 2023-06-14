//
//  AppCoordinatorView.swift
//  Coordinator
//
//  Created by GREEN on 2023/04/28.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Combine
import ComposableArchitecture
import NewsCardCoordinator
import SetCategory
import SettingCoordinator
import Splash
import SwiftUI
import TabBar
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
          state: /AppScreenState.tabBar,
          action: AppScreenAction.tabBar,
          then: TabBarView.init
        )
        CaseLet(
          state: /AppScreenState.newsCard,
          action: AppScreenAction.newsCard,
          then: NewsCardCoordinatorView.init
        )
      }
    }
  }
}

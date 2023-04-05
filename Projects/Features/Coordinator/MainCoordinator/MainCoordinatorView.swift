//
//  MainCoordinatorView.swift
//  MainCoordinator
//
//  Created by GREEN on 2023/04/05.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import ComposableArchitecture
import Home
import Setting
import SwiftUI
import TCACoordinators

public struct MainCoordinatorView: View {
  private let store: Store<MainCoordinatorState, MainCoordinatorAction>
  
  public init(store: Store<MainCoordinatorState, MainCoordinatorAction>) {
    self.store = store
  }
  
  public var body: some View {
    VStack(spacing: 0) {
      TCARouter(store) { screen in
        SwitchStore(screen) {
          CaseLet(
            state: /MainScreenState.home,
            action: MainScreenAction.home,
            then: HomeView.init
          )
          CaseLet(
            state: /MainScreenState.setting,
            action: MainScreenAction.setting,
            then: SettingView.init
          )
        }
      }
    }
    .edgesIgnoringSafeArea(.all)
  }
}

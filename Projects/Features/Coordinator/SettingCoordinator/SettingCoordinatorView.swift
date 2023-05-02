//
//  SettingCoordinatorView.swift
//  Coordinator
//
//  Created by GREEN on 2023/04/28.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import ComposableArchitecture
import Setting
import SwiftUI
import TCACoordinators

public struct SettingCoordinatorView: View {
  private let store: Store<SettingCoordinatorState, SettingCoordinatorAction>
  
  public init(store: Store<SettingCoordinatorState, SettingCoordinatorAction>) {
    self.store = store
  }
  
  public var body: some View {
    VStack(spacing: 0) {
      TCARouter(store) { screen in
        SwitchStore(screen) {
          CaseLet(
            state: /SettingScreenState.setting,
            action: SettingScreenAction.setting,
            then: SettingView.init
          )
        }
      }
    }
    .edgesIgnoringSafeArea(.all)
  }
}

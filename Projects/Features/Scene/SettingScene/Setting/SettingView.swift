//
//  SettingView.swift
//  Scene
//
//  Created by GREEN on 2023/04/28.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import ComposableArchitecture
import DesignSystem
import SwiftUI

public struct SettingView: View {
  private let store: Store<SettingState, SettingAction>
  
  public init(store: Store<SettingState, SettingAction>) {
    self.store = store
  }
  
  public var body: some View {
    WithViewStore(store) { viewStore in
      VStack(spacing: 0) {
        TopNavigationBar(
          title: "설정",
          leftIcon: DesignSystem.Icons.iconNavigationLeft,
          leftIconButtonAction: {
            viewStore.send(.backButtonTapped)
          }
        )
        
        Spacer()
      }
      .onDisappear { viewStore.send(._onDisappear) }
    }
    .navigationBarHidden(true)
  }
}

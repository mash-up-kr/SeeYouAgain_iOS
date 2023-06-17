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
          leftIcon: DesignSystem.Icons.iconNavigationLeft,
          leftIconButtonAction: {
            viewStore.send(.backButtonTapped)
          }
        )
        
        Text("설정화면")
        
        Spacer()
      }
    }
    .navigationBarHidden(true)
  }
}

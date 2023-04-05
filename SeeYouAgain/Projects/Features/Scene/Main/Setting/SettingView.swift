//
//  SettingView.swift
//  Setting
//
//  Created by GREEN on 2023/04/05.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Common
import ComposableArchitecture
import DesignSystem
import NukeUI
import SwiftUI

public struct SettingView: View {
  private let store: Store<SettingState, SettingAction>
  
  public init(store: Store<SettingState, SettingAction>) {
    self.store = store
  }
  
  public var body: some View {
    WithViewStore(store) { viewStore in
      Button(
        action: {
          viewStore.send(.backButtonTapped)
        },
        label: {
          Text("홈 화면으로 다시 슝~")
        }
      )
    }
    .navigationBarHidden(true)
  }
}

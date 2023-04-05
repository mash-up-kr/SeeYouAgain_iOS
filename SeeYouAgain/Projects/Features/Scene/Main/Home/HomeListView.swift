//
//  HomeListView.swift
//  Home
//
//  Created by GREEN on 2023/04/05.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import ComposableArchitecture
import DesignSystem
import Models
import NukeUI
import SwiftUI

public struct HomeView: View {
  private let store: Store<HomeState, HomeAction>
  
  public init(store: Store<HomeState, HomeAction>) {
    self.store = store
  }
  
  public var body: some View {
    WithViewStore(store) { viewStore in
      Button(
        action: {
          viewStore.send(.moveToSettingButtonTapped)
        },
        label: {
          Text("설정 화면으로 슝~")
        }
      )
    }
    .navigationBarHidden(true)
  }
}

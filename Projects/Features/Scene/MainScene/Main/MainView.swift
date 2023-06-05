//
//  MainView.swift
//  Main
//
//  Created by GREEN on 2023/04/05.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import ComposableArchitecture
import DesignSystem
import SwiftUI

public struct MainView: View {
  private let store: Store<MainState, MainAction>
  
  public init(store: Store<MainState, MainAction>) {
    self.store = store
  }
  
  public var body: some View {
    WithViewStore(store) { viewStore in
      HStack {
        VStack {
          Text("메인화면")
          Spacer()
        }
        Spacer()
      }
      .background(Color.blue)
    }
    .navigationBarHidden(true)
  }
}

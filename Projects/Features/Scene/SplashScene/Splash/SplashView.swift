//
//  SplashView.swift
//  Scene
//
//  Created by GREEN on 2023/04/28.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import ComposableArchitecture
import DesignSystem
import SwiftUI

public struct SplashView: View {
  private let store: Store<SplashState, SplashAction>
  
  public init(store: Store<SplashState, SplashAction>) {
    self.store = store
  }
  
  public var body: some View {
    WithViewStore(store) { viewStore in
      VStack(alignment: .center) {
        Spacer()
          .frame(height: 285)
        
        DesignSystem.Icons.logo
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(height: 128)
        
        Spacer()
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .background(DesignSystem.Colors.lightBlue)
      .onAppear { viewStore.send(._onAppear) }
    }
    .navigationBarHidden(true)
  }
}

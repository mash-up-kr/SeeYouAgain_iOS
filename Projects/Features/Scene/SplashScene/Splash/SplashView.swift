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
      VStack(alignment: .center, spacing: 16) {
        Spacer()
          .frame(height: 264)
        
        DesignSystem.Images.shorts
          .resizable()
          .frame(width: 130, height: 34)
        
        HStack(spacing: 0) {
          Text("키워드로 보는 ")
            .font(.r16)
            .foregroundColor(DesignSystem.Colors.grey90)
          Text("짧은 뉴스")
            .font(.b16)
            .foregroundColor(DesignSystem.Colors.grey90)
        }
        
        Spacer()
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .shortsBackgroundView()
      .onAppear { viewStore.send(._onAppear) }
    }
    .navigationBarHidden(true)
  }
}

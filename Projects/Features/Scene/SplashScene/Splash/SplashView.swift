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
      // TODO: - 추후 로딩 화면 스플래쉬 이미지와 동일하게 변경 예정
      Text("스플래쉬 화면")
    }
    .navigationBarHidden(true)
  }
}


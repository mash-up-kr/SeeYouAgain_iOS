//
//  LetterTop.swift
//  Main
//
//  Created by 김영균 on 2023/06/11.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import ComposableArchitecture
import DesignSystem
import SwiftUI

struct LetterTop: View {
  private let store: Store<Bool, Never>
  
  init(store: Store<Bool, Never>) {
    self.store = store
  }
  
  var body: some View {
    WithViewStore(store) { viewStore in
      VStack {
        Spacer()
        
        DesignSystem.Images.letterTop
          .resizable()
          .scaledToFit()
          .opacity(viewStore.state ? 1 : 0)
      }
      .rotation3DEffect(.degrees(viewStore.state ? 0 : 180), axis: (x: 1, y: 0, z: 0))
    }
  }
}

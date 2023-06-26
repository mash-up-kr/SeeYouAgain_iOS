//
//  SaveGuideView.swift
//  Splash
//
//  Created by 김영균 on 2023/06/26.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import ComposableArchitecture
import DesignSystem
import SwiftUI

struct SaveGuideView: View {
  private let store: Store<SaveGuideState, SaveGuideAction>
  
  init(store: Store<SaveGuideState, SaveGuideAction>) {
    self.store = store
  }
  
  var body: some View {
    WithViewStore(store) { viewStore in
      VStack(spacing: 8) {
        DesignSystem.Icons.caretDown
          .offset(viewStore.caretDownOffset)
          .animation(.spring(), value: viewStore.caretDownOffset)
          
        Text("아래로 내려서 저장하기")
          .font(.b14)
          .foregroundColor(DesignSystem.Colors.grey70)
      }
      .onAppear { viewStore.send(._onAppear) }
    }
  }
}

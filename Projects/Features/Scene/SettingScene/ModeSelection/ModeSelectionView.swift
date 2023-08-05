//
//  ModeSelectionView.swift
//  Splash
//
//  Created by 김영균 on 2023/08/06.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import ComposableArchitecture
import DesignSystem
import SwiftUI

public struct ModeSelectionView: View {
  private let store: Store<ModeSelectionState, ModeSelectionAction>
  
  public init(store: Store<ModeSelectionState, ModeSelectionAction>) {
    self.store = store
  }
    
  public var body: some View {
    WithViewStore(store) { viewStore in
      VStack {
        TopNavigationBar(
          title: "모드 선택",
          leftIcon: DesignSystem.Icons.iconNavigationLeft,
          leftIconButtonAction: {
            viewStore.send(.backButtonTapped)
          }
        )
        
        Spacer()
        
        BottomButton(title: "변경")
      }
    }
    .navigationBarHidden(true)
  }
}

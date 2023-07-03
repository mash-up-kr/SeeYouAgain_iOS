//
//  ShortsCompleteView.swift
//  NewsList
//
//  Created by 안상희 on 2023/06/25.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import ComposableArchitecture
import DesignSystem
import SwiftUI

public struct ShortsCompleteView: View {
  private let store: Store<ShortsCompleteState, ShortsCompleteAction>
  
  public init(store: Store<ShortsCompleteState, ShortsCompleteAction>) {
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
        
        Spacer()
          .frame(height: 64)
        
        DesignSystem.Icons.iconCheckCircleBig
          .frame(width: 64, height: 64)
        
        Spacer()
          .frame(height: 24)
        
        VStack(spacing: 8) {
          Text("1숏스가 추가됐어요!")
            .font(.b20)
            .foregroundColor(DesignSystem.Colors.grey100)
          
          Text("이번 달 총 \(viewStore.state.totalShortsCount)숏스 달성했어요")
            .font(.r16)
            .foregroundColor(DesignSystem.Colors.grey80)
        }
        
        Spacer()
        
        BottomButton(title: "확인") {
          viewStore.send(.completeButtonTapped)
        }
      }
    }
    .navigationBarBackButtonHidden()
  }
}

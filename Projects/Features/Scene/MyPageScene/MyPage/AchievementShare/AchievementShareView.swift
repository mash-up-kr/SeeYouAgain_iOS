//
//  MyAchievementShareView.swift
//  MyPage
//
//  Created by 김영균 on 2023/07/29.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Common
import ComposableArchitecture
import DesignSystem
import Foundation
import SwiftUI

public struct AchievementShareView: View {
  private let store: Store<AchievementShareState, AchievementShareAction>
  
  public init(store: Store<AchievementShareState, AchievementShareAction>) {
    self.store = store
  }
  public var body: some View {
    WithViewStore(store) { viewStore in
      VStack {
        HStack(spacing: 0) {
          Spacer()
          
          DesignSystem.Icons.iconNavigationDismiss
            .renderingMode(.template)
            .resizable()
            .frame(width: 32, height: 32)
            .foregroundColor(DesignSystem.Colors.white)
            .onTapGesture {
              viewStore.send(.dismissButtonDidTapped)
            }
          
          Spacer().frame(width: 16)
        }
        .padding(.top, 14)
        
        Spacer()
        
        viewStore.state.achievementType.shareImage
        Text(viewStore.state.achievementType.rawValue)
        
        Spacer()
        
        BottomButton(
          title: "공유하기",
          action: {
            viewStore.send(.shareButtonDidTapped)
          }
        )
      }
      .shortsBackgroundView()
      .background {
        ActivityView(
          isPresented: viewStore.binding(
            get: \.activityViewIsPresented,
            send: AchievementShareAction._setActivityViewIsPresented
          ),
          activityItems: []
        )
      }
    }
  }
}


// TODO: - Share Image
extension AchievementType {
  var shareImage: Image {
    return DesignSystem.Images.shorts
  }
}

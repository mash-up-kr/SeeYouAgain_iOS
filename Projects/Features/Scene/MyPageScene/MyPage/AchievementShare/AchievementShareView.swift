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
import Models
import SwiftUI

public struct AchievementShareView: View {
  private let store: Store<AchievementShareState, AchievementShareAction>
  
  public init(store: Store<AchievementShareState, AchievementShareAction>) {
    self.store = store
  }
  
  public var body: some View {
    WithViewStore(store) { viewStore in
      VStack(spacing: 0) {
        dismissButton
          .padding(.top, 14)
        
        contents
          .padding(.top, 77)
        
        Spacer()
        
        BottomButton(
          title: "공유하기",
          action: {
            viewStore.send(.shareButtonDidTapped)
          }
        )
        .padding(.bottom, 48)
      }
      .background(
        DesignSystem.Images.bgRecord
          .resizable()
          .aspectRatio(contentMode: .fill)
          .edgesIgnoringSafeArea(.all)
      )
      .background(
        ActivityView(
          isPresented: viewStore.binding(
            get: \.activityViewIsPresented,
            send: AchievementShareAction._setActivityViewIsPresented
          ),
          activityItems: [viewStore.achievementType.shareImage].compactMap { $0 }
        )
      )
    }
  }
  
  private var dismissButton: some View {
    WithViewStore(store.stateless) { viewStore in
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
    }
  }
  
  private var contents: some View {
    WithViewStore(store, observe: \.achievementType) { viewStore in
      HStack {
        Spacer()
        
        VStack(spacing: 0) {
          DesignSystem.Icons.iconSelctLarge
          
          Text(viewStore.state.rawValue)
            .font(.b28)
            .foregroundColor(DesignSystem.Colors.white)
            .padding(.top, 40)
          
          Text(viewStore.state.shareDescription)
            .font(.r18)
            .foregroundColor(DesignSystem.Colors.white)
            .multilineTextAlignment(.center)
            .padding(.top, 10)
        }
        
        Spacer()
      }
    }
  }
}

// TODO: 공유 이미지로 교체.
fileprivate extension AchievementType {
  var shareImage: UIImage? {
    switch self {
    default:
      return UIImage(asset: ImageAsset(name: "img_share"))
    }
  }
}

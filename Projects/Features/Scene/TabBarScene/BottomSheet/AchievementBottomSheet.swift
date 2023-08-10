//
//  AchievementBottomSheetCore.swift
//  TabBar
//
//  Created by 김영균 on 2023/08/04.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Common
import DesignSystem
import Models
import SwiftUI

struct AchievementBottomSheet: ViewModifier {
  private let achievement: AchievementType
  @Binding private var isPresented: Bool
  
  init(achievement: AchievementType, isPresented: Binding<Bool>) {
    self.achievement = achievement
    self._isPresented = isPresented
  }
  
  func body(content: Content) -> some View {
    content
      .bottomSheet(
        backgroundColor: DesignSystem.Colors.white.opacity(0.62),
        isPresented: $isPresented,
        headerArea: { EmptyView() },
        content: { AchievementBottomSheetContent(achievement: achievement) },
        bottomArea: { EmptyView() }
      )
  }
}

fileprivate struct AchievementBottomSheetContent: View {
  private let achievement: AchievementType
  
  fileprivate init(achievement: AchievementType) {
    self.achievement = achievement
  }
  
  fileprivate var body: some View {
    HStack {
      Spacer()
      
      VStack(spacing: 0) {
        DesignSystem.Icons.iconLockBlack
          .resizable()
          .frame(width: 56, height: 56)
        
        Spacer().frame(height: 16)
        
        Text(achievement.rawValue)
          .font(.b24)
          .foregroundColor(DesignSystem.Colors.grey100)
        
        Spacer().frame(height: 8)
        
        Text(achievement.bottomSheetDescription)
          .font(.r18)
          .foregroundColor(DesignSystem.Colors.grey90)
          .multilineTextAlignment(.center)
        
        Spacer().frame(height: 40)
      }
      
      Spacer()
    }
  }
}

extension View {
  func achievementBottomSheet(achievement: AchievementType, isPresented: Binding<Bool>) -> some View {
    modifier(AchievementBottomSheet(achievement: achievement, isPresented: isPresented))
  }
}

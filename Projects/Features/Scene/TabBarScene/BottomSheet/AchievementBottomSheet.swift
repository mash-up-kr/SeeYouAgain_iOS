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
  private let achievement: Achievement
  @Binding private var isPresented: Bool
  
  init(achievement: Achievement, isPresented: Binding<Bool>) {
    self.achievement = achievement
    self._isPresented = isPresented
  }
  
  func body(content: Content) -> some View {
    content
      .bottomSheet(
        backgroundColor: DesignSystem.Colors.white,
        isPresented: $isPresented,
        headerArea: { EmptyView() },
        content: { AchievementBottomSheetContent(achievement: achievement) },
        bottomArea: { EmptyView() }
      )
  }
}

fileprivate struct AchievementBottomSheetContent: View {
  private let achievement: Achievement
  
  fileprivate init(achievement: Achievement) {
    self.achievement = achievement
  }
  
  fileprivate var body: some View {
    HStack {
      Spacer()
      
      VStack(spacing: 0) {
        achievement.isAchieved ? achievement.type.openedIcon : DesignSystem.Icons.iconBadgeLock
        
        Spacer().frame(height: 16)
        
        Text(achievement.type.rawValue)
          .font(.b24)
          .foregroundColor(DesignSystem.Colors.grey100)
        
        Spacer().frame(height: 8)
        
        Text(achievement.type.bottomSheetDescription)
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
  func achievementBottomSheet(achievement: Achievement, isPresented: Binding<Bool>) -> some View {
    modifier(AchievementBottomSheet(achievement: achievement, isPresented: isPresented))
  }
}

fileprivate extension AchievementType {
  var openedIcon: Image {
    switch self {
    case .threeDaysContinuousAttendance:
      return DesignSystem.Icons.iconBadgeThreeDays
      
    case .explorer:
      return DesignSystem.Icons.iconBadgeExplorer
      
    case .kingOfSharing:
      return DesignSystem.Icons.iconBadgeSharing
      
    case .excitedSave:
      return DesignSystem.Icons.iconBadgeExcitedSave
      
    case .firstAllReadShorts:
      return DesignSystem.Icons.iconBadgeHalfstart
      
    case .changeMode:
      return DesignSystem.Icons.iconBadgeRespectTaste
      
    case .tenDaysContinuousAttendance:
      return DesignSystem.Icons.iconBadgeTenDaysAttendance
    }
  }
}

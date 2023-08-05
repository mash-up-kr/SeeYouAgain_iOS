//
//  MyAchievementsView.swift
//  Splash
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

struct MyAchievementsView: View {
  private let store: Store<MyAchievementsState, MyAchievementsAction>
  
  init(store: Store<MyAchievementsState, MyAchievementsAction>) {
    self.store = store
  }
  
  var body: some View {
    WithViewStore(store) { viewStore in
      VStack(spacing: 0) {
        title
        
        Spacer().frame(height: 24)
        
        AchievementsGridView(store: store.scope(state: \.achievements))
      }
    }
  }
  
  private var title: some View {
    HStack {
      Text("나의 숏스 업적")
        .font(.b16)
        .foregroundColor(DesignSystem.Colors.grey80)
      
      Spacer()
    }
  }
}

fileprivate struct AchievementsGridView: View {
  private let columns = [
    GridItem(.flexible()),
    GridItem(.flexible()),
    GridItem(.flexible())
  ]
  private let store: Store<[Achievement], MyAchievementsAction>
  
  fileprivate init(store: Store<[Achievement], MyAchievementsAction>) {
    self.store = store
  }
  
  fileprivate var body: some View {
    WithViewStore(store) { viewStore in
      LazyVGrid(columns: columns, spacing: 24) {
        ForEach(viewStore.state, id: \.type) { achievement in
          AchievementBadgeView(achievement: achievement.type)
            .onTapGesture {
              viewStore.send(.achievementBadgeTapped(achievement))
            }
        }
      }
      .onAppear {
        viewStore.send(._onAppear)
      }
    }
  }
}

fileprivate struct AchievementBadgeView: View {
  private let achievement: AchievementType
  
  fileprivate init(achievement: AchievementType) {
    self.achievement = achievement
  }
  
  fileprivate var body: some View {
    VStack(spacing: 6) {
      Rectangle()
        .fill(DesignSystem.Colors.white)
        .frame(width: 98, height: 98)
        .cornerRadius(16)
        .overlay {
          DesignSystem.Icons.iconLockWhite
        }
      
      Text(achievement.rawValue)
        .font(.r12)
        .foregroundColor(DesignSystem.Colors.grey80)
    }
  }
}

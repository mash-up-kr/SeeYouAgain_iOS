//
//  StatisticsView.swift
//  MyPage
//
//  Created by 안상희 on 2023/07/29.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import ComposableArchitecture
import DesignSystem
import Models
import SwiftUI

struct StatisticsView: View {
  private let store: Store<StatisticsState, StatisticsAction>
  
  init(store: Store<StatisticsState, StatisticsAction>) {
    self.store = store
  }
  
  var body: some View {
    WithViewStore(store) { viewStore in
      VStack(spacing: 0) {
        HStack(spacing: 8) {
          Text("주간 숏스 통계")
            .font(.b16)
            .foregroundColor(DesignSystem.Colors.grey80)
          
          Spacer()
          
          Text("\(viewStore.state.currentWeek)")
            .font(.r16)
            .foregroundColor(DesignSystem.Colors.grey80)
        }
        
        Spacer()
          .frame(height: 16)
        
        VStack(spacing: 16) {
          WeeklyStatisticsView(
            store: store.scope(
              state: \.weeklyStatistics,
              action: StatisticsAction.weeklyStatisticsAction
            )
          )
          
          CategoryStatisticsView(
            store: store.scope(
              state: \.categoryStatistics,
              action: StatisticsAction.categoryStatisticsAction
            )
          )
        }
      }
    }
  }
}

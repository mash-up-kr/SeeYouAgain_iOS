//
//  StatisticsView.swift
//  MyPage
//
//  Created by 안상희 on 2023/07/29.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Common
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
        Spacer()
          .frame(height: 20)
        
        HStack(spacing: 0) {
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
        
        VStack(spacing: 32) {
          WeeklyStatisticsView(
            store: store.scope(
              state: \.weeklyStatistics,
              action: StatisticsAction.weeklyStatisticsAction
            )
          )
          
          ZStack(alignment: .topTrailing) {
            CategoryStatisticsView(
              store: store.scope(
                state: \.categoryStatistics,
                action: StatisticsAction.categoryStatisticsAction
              )
            )
            
            CategoryType(uppercasedName: viewStore.state.topReadCategory)?.image
              .frame(width: 140, height: 140)
              .offset(y: -45)
          }
          
          // 이번 주에 숏스를 읽은 경우에만 보여지는 연속 통계 뷰
          if !viewStore.state.statistics.dateOfShortsRead.thisWeek.isEmpty {
            ContinuousStatisticsView(
              store: store.scope(
                state: \.continuousStatistics,
                action: StatisticsAction.continuousStatisticsAction
              )
            )
          }
        }
      }
    }
  }
}

fileprivate extension CategoryType {
  var image: Image {
    switch self {
    case .politics:
      return DesignSystem.Images.statisticsPolitics
    case .economic:
      return DesignSystem.Images.statisticsEconomics
    case .society:
      return DesignSystem.Images.statisticsSociety
    case .world:
      return DesignSystem.Images.statisticsWorld
    case .culture:
      return DesignSystem.Images.statisticsCulture
    case .science:
      return DesignSystem.Images.statisticsScience
    }
  }
}

//
//  WeeklyStatisticsView.swift
//  MyPage
//
//  Created by 안상희 on 2023/07/30.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import ComposableArchitecture
import DesignSystem
import Models
import SwiftUI

struct WeeklyStatisticsView: View {
  private let store: Store<WeeklyStatisticsState, WeeklyStatisticsAction>
  
  init(store: Store<WeeklyStatisticsState, WeeklyStatisticsAction>) {
    self.store = store
  }
  
  var body: some View {
    WithViewStore(store) { viewStore in
      VStack(alignment: .leading, spacing: 0) {
        HStack(spacing: 0) {
          Text("이번 주")
            .font(.b21)
            .foregroundColor(DesignSystem.Colors.grey100)
          
          Spacer()
        }
        
        WeeklyStatisticsDescriptionView(store: store)
        
        Spacer()
          .frame(height: 32)
        
        WeeklyStatisticsGraphView(store: store)
          .frame(
            height: viewStore.state.shortsMaxPercentage == 0.0 ?
            96 : viewStore.state.shortsMaxPercentage * 96 + 46
          )
      }
      .padding(.horizontal, 24)
      .padding(.vertical, 32)
      .background(DesignSystem.Colors.white)
      .cornerRadius(16)
      .onAppear {
        viewStore.send(._onAppear)
      }
    }
  }
}


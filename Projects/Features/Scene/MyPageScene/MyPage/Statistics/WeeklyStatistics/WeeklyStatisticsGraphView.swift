//
//  WeeklyStatisticsGraphView.swift
//  MyPage
//
//  Created by 안상희 on 2023/08/07.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import ComposableArchitecture
import DesignSystem
import Models
import SwiftUI

struct WeeklyStatisticsGraphView: View {
  private let store: Store<WeeklyStatisticsState, WeeklyStatisticsAction>
  
  init(store: Store<WeeklyStatisticsState, WeeklyStatisticsAction>) {
    self.store = store
  }
  
  var body: some View {
    WithViewStore(store) { viewStore in
      GeometryReader { geometry in
        let sumOfSpace = geometry.size.width - CGFloat(viewStore.state.weeklyShortsCountList.count * 60)
        let spacing = sumOfSpace / CGFloat(viewStore.state.weeklyShortsCountList.count - 1)
        
        HStack(alignment: .bottom, spacing: spacing) {
          ForEach(0..<viewStore.state.weeklyShortsCountList.count, id: \.self) { index in
            VStack(spacing: 0) {
              if viewStore.state.weeklyShortsCountList[index].value != 0 {
                Text("\(viewStore.state.weeklyShortsCountList[index].value)개")
                  .font(.b14)
                  .foregroundColor(
                    index == 3 ? DesignSystem.Colors.blue200 : DesignSystem.Colors.grey80
                  )
                
                Spacer()
                  .frame(height: 3)
              } else {
                Spacer()
              }
              
              if !viewStore.state.weeklyShortsPercentageList.isEmpty {
                LinearGradient(
                  gradient: Gradient(
                    colors:
                      index == 3 ? [
                        Color(red: 0.14, green: 0.47, blue: 0.96).opacity(1.0),
                        Color(red: 0.14, green: 0.47, blue: 0.96).opacity(0.1)
                      ] : [
                        Color(red: 0.46, green: 0.47, blue: 0.47).opacity(0.8),
                        Color(red: 0.46, green: 0.47, blue: 0.47).opacity(0.1)
                      ]
                  ),
                  startPoint: .top,
                  endPoint: .bottom
                )
                .frame(
                  width: 30,
                  height: viewStore.state.weeklyShortsPercentageList[index] != 0.0
                  ? viewStore.state.weeklyShortsPercentageList[index] * 96 : 2
                )
                .cornerRadius(30, corners: .topLeft)
                .cornerRadius(30, corners: .topRight)
                
                Spacer()
                  .frame(height: 12)
                
                Text(viewStore.state.weeklyShortsCountList[index].key)
                  .lineLimit(1)
                  .font(.r12)
                  .foregroundColor(
                    index == 3 ? DesignSystem.Colors.blue200 : DesignSystem.Colors.grey80
                  )
              }
            }
            .frame(maxWidth: .infinity)
          }
        }
      }
    }
  }
}

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

private struct WeeklyStatisticsDescriptionView: View {
  private let store: Store<WeeklyStatisticsState, WeeklyStatisticsAction>
  
  fileprivate init(store: Store<WeeklyStatisticsState, WeeklyStatisticsAction>) {
    self.store = store
  }
  
  fileprivate var body: some View {
    WithViewStore(store) { viewStore in
      // 이번주 숏스 안 읽었을 경우
      if viewStore.state.shortsCountOfThisWeek == 0 {
        HStack(spacing: 0) {
          Text("아직 숏스를 읽지 못했어요")
            .font(.b21)
            .foregroundColor(DesignSystem.Colors.grey100)
          
          Spacer()
        }
        
        Spacer()
          .frame(height: 9)
        
        HStack {
          Text("이번 주도 열심히 읽어봐요")
            .font(.r14)
            .foregroundColor(DesignSystem.Colors.grey60)
          
          Spacer()
        }
      } else { // 이번주 숏스 읽었을 경우
        HStack(spacing: 0) {
          Text("\(viewStore.state.shortsCountOfThisWeek)개 ")
            .font(.b21)
            .foregroundColor(DesignSystem.Colors.blue200)
          
          Text("숏스를 읽었어요!")
            .font(.b21)
            .foregroundColor(DesignSystem.Colors.grey100)
          
          Spacer()
        }
        
        Spacer()
          .frame(height: 9)
        
        HStack(spacing: 0) {
          Text("저번 주보다 ")
            .font(.r14)
            .foregroundColor(DesignSystem.Colors.grey60)
          
          Text("\(viewStore.state.weeklyShortsCountDifference)개 더")
            .font(.b14)
            .foregroundColor(DesignSystem.Colors.grey60)
          
          Text(" 읽었어요")
            .font(.r14)
            .foregroundColor(DesignSystem.Colors.grey60)
          
          Spacer()
        }
      }
    }
  }
}

private struct WeeklyStatisticsGraphView: View {
  private let store: Store<WeeklyStatisticsState, WeeklyStatisticsAction>
  
  fileprivate init(store: Store<WeeklyStatisticsState, WeeklyStatisticsAction>) {
    self.store = store
  }
  
  fileprivate var body: some View {
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

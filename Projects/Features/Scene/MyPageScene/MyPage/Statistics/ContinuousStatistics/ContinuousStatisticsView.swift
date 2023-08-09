//
//  ContinuousStatisticsView.swift
//  MyPage
//
//  Created by 안상희 on 2023/08/01.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import ComposableArchitecture
import DesignSystem
import Models
import SwiftUI

struct ContinuousStatisticsView: View {
  private let store: Store<ContinuousStatisticsState, ContinuousStatisticsAction>
  
  init(store: Store<ContinuousStatisticsState, ContinuousStatisticsAction>) {
    self.store = store
  }
  
  var body: some View {
    WithViewStore(store) { viewStore in
      VStack(spacing: 0) {
        ContinuousStatisticsDescriptionView(store: store)
        
        Spacer()
          .frame(height: 24)
        
        ContinuousStatisticsGraphView(store: store)
          .frame(height: 34)
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

private struct ContinuousStatisticsDescriptionView: View {
  private let store: Store<ContinuousStatisticsState, ContinuousStatisticsAction>
  
  fileprivate init(store: Store<ContinuousStatisticsState, ContinuousStatisticsAction>) {
    self.store = store
  }
  
  fileprivate var body: some View {
    WithViewStore(store) { viewStore in
      VStack(spacing: 0) {
        HStack(spacing: 0) {
          Text("이번 주")
            .font(.b21)
            .foregroundColor(DesignSystem.Colors.grey100)
          
          Spacer()
        }
        
        HStack(spacing: 0) {
          Text("\(viewStore.state.consecutiveDaysOfThisWeek)일 연속 ")
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
          if !viewStore.state.consecutiveDaysDifference.isEmpty {
            Text("지난주보다 ")
              .font(.r14)
              .foregroundColor(DesignSystem.Colors.grey60)
            
            Text("\(viewStore.state.consecutiveDaysDifference)")
              .font(.b14)
              .foregroundColor(DesignSystem.Colors.grey60)
            
            Text(" 읽었어요")
              .font(.r14)
              .foregroundColor(DesignSystem.Colors.grey60)
            
            Spacer()
          } else {
            Text("읽은 날이 지난주와 같아요")
              .font(.r14)
              .foregroundColor(DesignSystem.Colors.grey60)
            
            Spacer()
          }
        }
      }
    }
  }
}

private struct ContinuousStatisticsGraphView: View {
  private let store: Store<ContinuousStatisticsState, ContinuousStatisticsAction>
  
  fileprivate init(store: Store<ContinuousStatisticsState, ContinuousStatisticsAction>) {
    self.store = store
  }
  
  fileprivate var body: some View {
    WithViewStore(store) { viewStore in
      GeometryReader { geometry in
        let sumOfSpace = geometry.size.width - CGFloat(viewStore.state.dayList.count * 34)
        let spacing = sumOfSpace / CGFloat(viewStore.state.dayList.count - 1)
        
        HStack(spacing: spacing) {
          ForEach(0..<viewStore.state.dayList.count, id: \.self) { index in
            ZStack {
              Circle()
                .foregroundColor(DesignSystem.Colors.coolgrey100)
                .frame(width: 34, height: 34)
              
              if !viewStore.state.dayList[index].isEmpty {
                Text("\(viewStore.state.dayList[index])")
                  .font(.b14)
                  .foregroundColor(
                    viewStore.state.dayListForCheckTodayStatusList[index] ?
                    DesignSystem.Colors.grey90 : DesignSystem.Colors.grey40
                  )
              } else {
                DesignSystem.Icons.iconShorts
                  .frame(width: 18, height: 34)
              }
            }
          }
        }
      }
    }
  }
}

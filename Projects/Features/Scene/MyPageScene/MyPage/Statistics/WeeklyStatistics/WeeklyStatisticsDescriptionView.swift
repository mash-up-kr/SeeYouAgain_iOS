//
//  WeeklyStatisticsDescriptionView.swift
//  MyPage
//
//  Created by 안상희 on 2023/08/07.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import ComposableArchitecture
import DesignSystem
import Models
import SwiftUI

struct WeeklyStatisticsDescriptionView: View {
  private let store: Store<WeeklyStatisticsState, WeeklyStatisticsAction>
  
  init(store: Store<WeeklyStatisticsState, WeeklyStatisticsAction>) {
    self.store = store
  }
  
  var body: some View {
    WithViewStore(store) { viewStore in
      // 이번주 숏스 안 읽었을 경우
      if viewStore.state.shortsCountOfThisWeek == 0 {
        WeeklyStatisticsInitialDescriptionView()
      } else { // 이번주 숏스 읽었을 경우
        WeeklyStatisticsActualDescriptionView(store: store)
      }
    }
  }
}

// 이번주 숏스 읽었을 경우
private struct WeeklyStatisticsActualDescriptionView: View {
  private let store: Store<WeeklyStatisticsState, WeeklyStatisticsAction>
  
  fileprivate init(store: Store<WeeklyStatisticsState, WeeklyStatisticsAction>) {
    self.store = store
  }
  
  fileprivate var body: some View {
    WithViewStore(store) { viewStore in
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
        if viewStore.state.weeklyShortsCountDifferenceString.isEmpty {
          Text("읽은 숏스 수가 지난주와 같아요.")
            .font(.r14)
            .foregroundColor(DesignSystem.Colors.grey60)
        } else {
          Text("저번 주보다 ")
            .font(.r14)
            .foregroundColor(DesignSystem.Colors.grey60)
          
          Text("\(viewStore.state.weeklyShortsCountDifferenceString)")
            .font(.b14)
            .foregroundColor(DesignSystem.Colors.grey60)
          
          Text(" 읽었어요")
            .font(.r14)
            .foregroundColor(DesignSystem.Colors.grey60)
        }
        
        Spacer()
      }
    }
  }
}

// 이번주 숏스 안 읽었을 경우
private struct WeeklyStatisticsInitialDescriptionView: View {
  fileprivate var body: some View {
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
  }
}

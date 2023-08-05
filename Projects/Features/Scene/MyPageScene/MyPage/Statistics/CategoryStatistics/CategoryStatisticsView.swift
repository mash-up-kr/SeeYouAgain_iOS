//
//  CategoryStatisticsView.swift
//  MyPage
//
//  Created by 안상희 on 2023/07/30.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import ComposableArchitecture
import DesignSystem
import Models
import SwiftUI

struct CategoryStatisticsView: View {
  private let store: Store<CategoryStatisticsState, CategoryStatisticsAction>
  
  init(store: Store<CategoryStatisticsState, CategoryStatisticsAction>) {
    self.store = store
  }
  
  var body: some View {
    WithViewStore(store) { viewStore in
      VStack(spacing: 0) {
        HStack(spacing: 0) {
          Text("이번 주")
            .font(.b21)
            .foregroundColor(DesignSystem.Colors.grey100)
          
          Spacer()
        }
        
        CategoryStatisticsDescriptionView(store: store)
        
        Spacer()
          .frame(height: 32)
        
        CategoryStatisticsGraphView(store: store)
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

private struct CategoryStatisticsDescriptionView: View {
  private let store: Store<CategoryStatisticsState, CategoryStatisticsAction>
  
  fileprivate init(store: Store<CategoryStatisticsState, CategoryStatisticsAction>) {
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
          Text("숏스를 읽으면 통계를 볼 수 있어요")
            .font(.r14)
            .foregroundColor(DesignSystem.Colors.grey60)
          
          Spacer()
        }
      } else { // 이번주 숏스 읽었을 경우
        HStack(spacing: 0) {
          Text("\(viewStore.state.topReadCategory)")
            .font(.b21)
            .foregroundColor(DesignSystem.Colors.blue200)
          
          Text("에 가장 관심있어요!")
            .font(.b21)
            .foregroundColor(DesignSystem.Colors.grey100)
          
          Spacer()
        }
        
        Spacer()
          .frame(height: 9)
        
        HStack(spacing: 0) {
          Text("\(viewStore.state.topReadCategory) 뉴스를 ")
            .font(.r14)
            .foregroundColor(DesignSystem.Colors.grey60)
          
          Text("\(viewStore.state.topReadCount)개")
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

private struct CategoryStatisticsGraphView: View {
  private let store: Store<CategoryStatisticsState, CategoryStatisticsAction>
  
  fileprivate init(store: Store<CategoryStatisticsState, CategoryStatisticsAction>) {
    self.store = store
  }
  
  fileprivate var body: some View {
    WithViewStore(store) { viewStore in
      // TODO: API 나오면 그래프 구현
      Text("응답 모델 나오면 그래프 표시 예정")
    }
  }
}

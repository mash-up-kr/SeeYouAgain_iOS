//
//  CategoryStatisticsView.swift
//  MyPage
//
//  Created by 안상희 on 2023/07/30.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Common
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
          .frame(height: 135) // 20 + 32 + 83
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
      if !viewStore.categoryOfInterestPercentageList.isEmpty {
        VStack(spacing: 32) {
          GeometryReader { geometry in
            HStack(spacing: 2) {
              ForEach(1..<viewStore.categoryOfInterestPercentageList.count, id: \.self) { index in
                Group {
                  CategoryType(
                    uppercasedName: viewStore.categoryOfInterestPercentageList[index].key
                  )?.color ?? DesignSystem.Colors.grey40
                }
                .frame(
                  width: viewStore.categoryOfInterestPercentageList[index].value * geometry.size.width
                )
              }
            }
          }
          .cornerRadius(8)
          
          VStack(spacing: 16) {
            ForEach(1..<viewStore.categoryOfInterestPercentageList.count - 1, id: \.self) { index in
              HStack(spacing: 16) {
                Circle()
                  .foregroundColor(
                    CategoryType(
                      uppercasedName: viewStore.categoryOfInterestPercentageList[index].key
                    )?.color ?? DesignSystem.Colors.grey40)
                  .frame(width: 6, height: 6)
                
                Text(CategoryType(uppercasedName: viewStore.categoryOfInterestList[index].key)?.rawValue ?? "카테고리 없음")
                  .font(.b14)
                  .foregroundColor(DesignSystem.Colors.grey80)
                
                Spacer()
                
                Text("\(viewStore.categoryOfInterestList[index].value)숏스")
                  .font(.r14)
                  .foregroundColor(DesignSystem.Colors.grey60)
              }
            }
          }
        }
      } else {
        VStack(spacing: 16) {
          DesignSystem.Colors.grey40
            .frame(height: 20)
            .frame(maxWidth: .infinity)
            .cornerRadius(8)
          
          Spacer()
            .frame(height: .none)
          
          ForEach(0..<viewStore.categoryOfInterestList.count, id: \.self) { index in
            HStack(spacing: 16) {
              Circle()
                .foregroundColor(
                  CategoryType(
                    uppercasedName: viewStore.categoryOfInterestList[index].key
                  )?.color ?? DesignSystem.Colors.grey40)
                .frame(width: 6, height: 6)
              
              Text(CategoryType(uppercasedName: viewStore.categoryOfInterestList[index].key)?.rawValue ?? "카테고리 없음")
                .font(.b14)
                .foregroundColor(DesignSystem.Colors.grey80)
              
              Spacer()
              
              Text("\(viewStore.categoryOfInterestList[index].value)숏스")
                .font(.r14)
                .foregroundColor(DesignSystem.Colors.grey60)
            }
          }
        }
      }
    }
  }
}

fileprivate extension CategoryType {
  var color: Color {
    switch self {
    case .politics:
      return DesignSystem.Colors.politics
    case .economic:
      return DesignSystem.Colors.economic
    case .society:
      return DesignSystem.Colors.society
    case .world:
      return DesignSystem.Colors.world
    case .culture:
      return DesignSystem.Colors.culture
    case .science:
      return DesignSystem.Colors.science
    }
  }
}

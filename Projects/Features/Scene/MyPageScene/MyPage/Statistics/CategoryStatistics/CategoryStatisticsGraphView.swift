//
//  CategoryStatisticsGraphView.swift
//  MyPage
//
//  Created by 안상희 on 2023/08/07.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Common
import ComposableArchitecture
import DesignSystem
import Models
import SwiftUI

struct CategoryStatisticsGraphView: View {
  private let store: Store<CategoryStatisticsState, CategoryStatisticsAction>
  
  init(store: Store<CategoryStatisticsState, CategoryStatisticsAction>) {
    self.store = store
  }
  
  var body: some View {
    WithViewStore(store) { viewStore in
      if !viewStore.categoryOfInterestPercentageList.isEmpty {
        CategoryStatisticsActualView(store: store)
      } else {
        CategoryStatisticsInitialGraphView(store: store)
      }
    }
  }
}

// 실제 데이터 담은 뷰
private struct CategoryStatisticsActualView: View {
  private let store: Store<CategoryStatisticsState, CategoryStatisticsAction>

  fileprivate init(store: Store<CategoryStatisticsState, CategoryStatisticsAction>) {
    self.store = store
  }
  
  fileprivate var body: some View {
    WithViewStore(store) { viewStore in
      VStack(spacing: 32) {
        GeometryReader { geometry in
          HStack(spacing: 2) {
            ForEach(0..<viewStore.categoryOfInterestPercentageList.count, id: \.self) { index in
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
          ForEach(0..<viewStore.categoryOfInterestList.count, id: \.self) { index in
            HStack(spacing: 16) {
              Circle()
                .foregroundColor(
                  CategoryType(
                    uppercasedName: viewStore.categoryOfInterestPercentageList[index].key
                  )?.color ?? DesignSystem.Colors.grey40)
                .frame(width: 6, height: 6)
              
              Text(
                CategoryType(
                  uppercasedName: viewStore.categoryOfInterestList[index].key
                )?.rawValue ?? "카테고리 없음"
              )
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

// 데이터가 없을 때 표시할 뷰
private struct CategoryStatisticsInitialGraphView: View {
  private let store: Store<CategoryStatisticsState, CategoryStatisticsAction>

  fileprivate init(store: Store<CategoryStatisticsState, CategoryStatisticsAction>) {
    self.store = store
  }
  
  fileprivate var body: some View {
    WithViewStore(store) { viewStore in
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

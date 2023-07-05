//
//  CategoryFilterBottomSheetHeader.swift
//  Splash
//
//  Created by 김영균 on 2023/07/05.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Common
import ComposableArchitecture
import DesignSystem
import SwiftUI

struct CategoryFilterBottomSheetHeader: View {
  private let store: Store<CategoryFilterBottomSheetState, CategoryFilterBottomSheetAction>
  
  init(store: Store<CategoryFilterBottomSheetState, CategoryFilterBottomSheetAction>) {
    self.store = store
  }
  
  var body: some View {
    WithViewStore(store, observe: \.selectedCategories) { viewStore in
      VStack {
        HStack {
          Text("필터")
            .font(.b18)
            .foregroundColor(DesignSystem.Colors.grey100)
          Spacer()
        }
        
        Spacer()
          .frame(height: 16)
        
        ScrollView(.horizontal, showsIndicators: false) {
          HStack(spacing: 8) {
            ForEach(
              viewStore.state.sorted(by: { $0.indexValue < $1.indexValue }),
              id: \.self
            ) { category in
              CategoryBadge(category: category)
                .onTapGesture {
                  viewStore.send(.selectCategory(category))
                }
            }
          }
        }
      }
      .padding(.horizontal, 24)
    }
  }
}

private struct CategoryBadge: View {
  private let category: CategoryType
  
  fileprivate init(category: CategoryType) {
    self.category = category
  }
  
  fileprivate var body: some View {
    HStack(spacing: 2) {
      Text(category.rawValue)
        .font(.r14)
        .foregroundColor(DesignSystem.Colors.grey90)
        .frame(height: 17)
      
      DesignSystem.Icons.iconX
        .frame(width: 14, height: 14)
    }
    .padding(.leading, 14)
    .padding(.trailing, 10)
    .padding(.vertical, 8)
    .background(DesignSystem.Colors.grey20)
    .cornerRadius(24)
    .overlay {
      RoundedRectangle(cornerRadius: 24)
        .strokeBorder(
          LinearGradient(
            colors: [
              DesignSystem.Colors.white,
              DesignSystem.Colors.white.opacity(0.2)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
          ),
          lineWidth: 1
        )
    }
  }
}

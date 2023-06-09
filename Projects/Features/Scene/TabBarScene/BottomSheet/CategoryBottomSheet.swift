//
//  CategoryBottomSheet.swift
//  Main
//
//  Created by 김영균 on 2023/06/08.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import ComposableArchitecture
import DesignSystem
import SwiftUI

struct CategoryBottomSheetHeader: View {
  var body: some View {
    HStack {
      Text("관심 키워드를 선택해주세요")
        .font(.b18)
        .foregroundColor(DesignSystem.Colors.grey100)
      Spacer()
    }
    .padding(.horizontal, 24)
  }
}

struct CategoryBottomSheet: View {
  private let columns = [
    GridItem(.flexible()),
    GridItem(.flexible()),
    GridItem(.flexible()),
    GridItem(.flexible())
  ]
  private let store: Store<CategoryBottomSheetState, CategoryBottomSheetAction>
  
  init(store: Store<CategoryBottomSheetState, CategoryBottomSheetAction>) {
    self.store = store
  }
  
  var body: some View {
    WithViewStore(store) { viewStore in
      ScrollView {
        LazyVGrid(columns: columns, spacing: 12) {
          ForEach(viewStore.state.categories, id: \.id) { category in
            HStack {
              Spacer()
                            
              VStack(spacing: 2) {
                DesignSystem.Icons.badge
                  .frame(width: 28, height: 28)
                Text(category.name)
                  .font(.b14)
                  .foregroundColor(DesignSystem.Colors.grey100)
              }
              
              Spacer()
            }
            .frame(height: 80)
            .background(category.isSelected ? DesignSystem.Colors.grey50 : DesignSystem.Colors.white)
            .cornerRadius(8)
            .onTapGesture {
              viewStore.send(._toggleCategory(category))
            }
          }
        }
      }
      .scrollDisabled(true)
      .frame(height: 172)
    }
  }
}

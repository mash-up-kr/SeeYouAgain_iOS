//
//  CategoryBottomSheet.swift
//  Main
//
//  Created by 김영균 on 2023/06/08.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import ComposableArchitecture
import DesignSystem
import Models
import SwiftUI

public typealias Category = Models.Category
struct CategoryBottomSheet: View {
  private let columns = [
    GridItem(.flexible()),
    GridItem(.flexible()),
    GridItem(.flexible()),
    GridItem(.flexible())
  ]
  private let store: Store<BottomSheetState, BottomSheetAction>
  
  init(store: Store<BottomSheetState, BottomSheetAction>) {
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
              viewStore.send(.toggleCategory(category))
            }
          }
        }
      }
      .scrollDisabled(true)
      .frame(height: 172)
    }
  }
}

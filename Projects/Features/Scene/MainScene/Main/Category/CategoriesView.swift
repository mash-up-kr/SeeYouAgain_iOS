//
//  CategoriesView.swift
//  Main
//
//  Created by 김영균 on 2023/06/08.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import ComposableArchitecture
import DesignSystem
import SwiftUI

struct CategoriesView: View {
  private let store: Store<[Category], MainAction>
  
  init(store: Store<[Category], MainAction>) {
    self.store = store
  }
  
  var body: some View {
    WithViewStore(store) { viewStore in
      ScrollView(.horizontal, showsIndicators: false) {
        HStack(spacing: 8) {
          ForEach(viewStore.state, id: \.id) { category in
            if category.isSelected,
              let category = CategoryType(rawValue: category.name) {
              CategoryBadgeButton(name: category.rawValue, icon: category.icon) {
                // TODO: filter news cards.
              }
            }
          }
          
          CategoryDetailButton {
            viewStore.send(.showCategoryBottomSheet(viewStore.state))
          }
          
          Spacer()
        }
        .padding(.horizontal, 24)
        .animation(.easeInOut, value: viewStore.state)
      }
    }
  }
}

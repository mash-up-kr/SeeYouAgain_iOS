//
//  CategoriesView.swift
//  Main
//
//  Created by 김영균 on 2023/06/08.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Common
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
      HStack(spacing: 0) {
        LinearGradient(
          colors: [
            Color(red: 222, green: 234, blue: 243).opacity(0),
            Color(red: 222, green: 234, blue: 243)
          ],
          startPoint: .leading,
          endPoint: .trailing
        )
        .frame(width: 40)
        
        ScrollView(.horizontal, showsIndicators: false) {
          HStack(spacing: 8) {
            ForEach(viewStore.state, id: \.id) { category in
              if category.isSelected, let category = CategoryType(rawValue: category.name) {
                CategoryBadge(name: category.rawValue)
              }
            }
          }
          .animation(.easeInOut, value: viewStore.state)
        }
        
        LinearGradient(
          colors: [
            Color(hex: 0xEBF2F6).opacity(0),
            Color(hex: 0xEBF2F6)
          ],
          startPoint: .leading,
          endPoint: .trailing
        )
        .frame(width: 40)
        
        Spacer().frame(width: 16)
        
        CategoryDetailButton {
          viewStore.send(.showCategoryBottomSheet(viewStore.state))
        }
        
        Spacer().frame(width: 24)
      }
    }
  }
}

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
        ScrollView(.horizontal, showsIndicators: false) {
          HStack(spacing: 8) {
            ForEach(viewStore.state, id: \.id) { category in
              if category.isSelected, let category = CategoryType(rawValue: category.name) {
                CategoryBadge(name: category.rawValue)
              }
            }
          }
          .animation(.easeInOut, value: viewStore.state)
          .offset(x: 24)
        }
        .overlay {
          GradientView()
        }
        
        Spacer()
          .frame(width: 16)
        
        CategoryDetailButton {
          viewStore.send(.showCategoryBottomSheet(viewStore.state))
        }
        
        Spacer()
          .frame(width: 24)
      }
    }
  }
}

private struct GradientView: View {
  fileprivate var body: some View {
    HStack {
      LinearGradient(
        colors: [
          DesignSystem.Colors.lightBlue,
          DesignSystem.Colors.lightBlue.opacity(0)
        ],
        startPoint: .leading,
        endPoint: .trailing
      )
      .frame(width: 40, height: 32)
      
      Spacer()
      
      LinearGradient(
        colors: [
          DesignSystem.Colors.skyBlue.opacity(0),
          DesignSystem.Colors.skyBlue
        ],
        startPoint: .leading,
        endPoint: .trailing
      )
      .frame(width: 40, height: 32)
    }
  }
}

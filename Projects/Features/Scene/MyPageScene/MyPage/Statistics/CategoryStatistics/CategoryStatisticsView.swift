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
            .frame(height: viewStore.state.graphHeight)
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

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

struct CategoryBottomSheet: View {
  private let store: Store<[Category], MainAction>
  
  init(store: Store<[Category], MainAction>) {
    self.store = store
  }
  
  var body: some View {
    WithViewStore(store) { viewStore in
      VStack(spacing: 32) {
        title
          .padding(.horizontal, 24)
        
        categoires
          .padding(.horizontal, 24)
        
        BottomButton(title: "변경") {
          viewStore.send(.updateButtonTapped)
        }
      }
      .padding(.top, 32)
      .padding(.bottom, 42)
      .background(DesignSystem.Colors.white.opacity(0.8).blurEffect())
      .cornerRadius(20, corners: [.topLeft, .topRight])
    }
  }
  
  var title: some View {
    HStack {
      Text("관심 키워드를 선택해주세요")
        .font(.b18)
        .foregroundColor(DesignSystem.Colors.grey100)
      
      Spacer()
    }
  }
  
  var categoires: some View {
    VStack(spacing: 12) {
      CategoryRow(store: store.scope(state: { Array($0[0..<4]) }))
        .frame(height: 80)
      
      CategoryRow(store: store.scope(state: { Array($0[4..<8]) }))
        .frame(height: 80)
    }
  }
}

struct CategoryRow: View {
  let store: Store<[Category], MainAction>
  
  var body: some View {
    WithViewStore(store) { viewStore in
      HStack(spacing: 12) {
        ForEach(viewStore.state, id: \.id) { category in
          CategoryCell(category: category)
            .onTapGesture {
              viewStore.send(.toggleCategorySelected(category))
            }
        }
      }
    }
  }
}

struct CategoryCell: View {
  let category: Category
  
  var body: some View {
    HStack(spacing: 0) {
      Spacer()
      
      VStack(spacing: 0) {
        Spacer()
        DesignSystem.Icons.badge
          .frame(width: 28, height: 28)
        Text(category.name)
          .font(.b14)
          .foregroundColor(DesignSystem.Colors.grey100)
        Spacer()
      }
      
      Spacer()
    }
    .background(DesignSystem.Colors.white)
    .cornerRadius(8)
  }
}

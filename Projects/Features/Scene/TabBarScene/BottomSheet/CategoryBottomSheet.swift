//
//  CategoryBottomSheet.swift
//  Main
//
//  Created by 김영균 on 2023/06/08.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Common
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
          ForEach(viewStore.allCategories, id: \.self) { category in
            CategoryItemView(
              store: store.stateless,
              category: category,
              isSelected: viewStore.selectedCategories.contains(category)
            )
          }
        }
      }
      .scrollDisabled(true)
      .frame(height: 218)
    }
  }
}

// MARK: - 카테고리 아이템 뷰
private struct CategoryItemView: View {
  private let store: Store<Void, CategoryBottomSheetAction>
  private var category: CategoryType
  @State private var isSelected: Bool
  
  private var iconImage: Image {
    if isSelected {
      return category.selectedIcon
    } else {
      return category.defaultIcon
    }
  }
  
  fileprivate init(
    store: Store<Void, CategoryBottomSheetAction>,
    category: CategoryType,
    isSelected: Bool
  ) {
    self.store = store
    self.category = category
    self.isSelected = isSelected
  }
  
  fileprivate var body: some View {
    WithViewStore(store) { viewStore in
      VStack(spacing: 8) {
        iconImage
          .frame(width: 76, height: 76)
          .background(
            RoundedRectangle(cornerRadius: 16)
              .fill(
                LinearGradient(
                  colors: [
                    DesignSystem.Colors.white.opacity(0.6),
                    DesignSystem.Colors.white.opacity(0.3)
                  ],
                  startPoint: .topLeading,
                  endPoint: .bottomTrailing
                )
              )
          )
          .onTapGesture {
            isSelected.toggle()
            viewStore.send(.categoryTapped(category))
          }
        
        Text(category.rawValue)
          .font(.r14)
          .foregroundColor(DesignSystem.Colors.grey100)
      }
    }
  }
}

// MARK: - 카테고리 타입 Extension
fileprivate extension CategoryType {
  var defaultIcon: Image {
    switch self {
    case .politics:
      return DesignSystem.Icons.politics
    case .economic:
      return DesignSystem.Icons.economics
    case .society:
      return DesignSystem.Icons.society
    case .world:
      return DesignSystem.Icons.world
    case .culture:
      return DesignSystem.Icons.culture
    case .science:
      return DesignSystem.Icons.science
    }
  }
  
  var selectedIcon: Image {
    switch self {
    case .politics:
      return DesignSystem.Icons.selectedPolitics
    case .economic:
      return DesignSystem.Icons.selectedEconomics
    case .society:
      return DesignSystem.Icons.selectedSociety
    case .world:
      return DesignSystem.Icons.selectedWorld
    case .culture:
      return DesignSystem.Icons.selectedCulture
    case .science:
      return DesignSystem.Icons.selectedScience
    }
  }
}

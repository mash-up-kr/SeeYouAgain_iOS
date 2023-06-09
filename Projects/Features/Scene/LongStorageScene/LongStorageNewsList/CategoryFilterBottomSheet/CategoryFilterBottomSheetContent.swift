//
//  CategoryFilterBottomSheetContent.swift
//  Splash
//
//  Created by 김영균 on 2023/07/05.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Common
import ComposableArchitecture
import DesignSystem
import SwiftUI

struct CategoryFilterBottomSheetContent: View {
  private let columns = [
    GridItem(.flexible()),
    GridItem(.flexible()),
    GridItem(.flexible()),
    GridItem(.flexible())
  ]
  private let store: Store<CategoryFilterBottomSheetState, CategoryFilterBottomSheetAction>
  
  init(store: Store<CategoryFilterBottomSheetState, CategoryFilterBottomSheetAction>) {
    self.store = store
  }
  
  var body: some View {
    WithViewStore(store) { viewStore in
      ScrollView {
        LazyVGrid(columns: columns, spacing: 16) {
          ForEach(viewStore.allCateogires, id: \.self) { category in
            CategoryItemView(
              selectedCategories: viewStore.binding(
                get: \.selectedCategories,
                send: CategoryFilterBottomSheetAction._setSelectedCategories
              ),
              category: category
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
  @Binding private var selectedCategories: Set<CategoryType>
  private var category: CategoryType
  private var isSelected: Bool { selectedCategories.contains(category) }
  private var iconImage: Image {
    if isSelected {
      return category.selectedIcon
    } else {
      return category.defaultIcon
    }
  }
  
  fileprivate init(
    selectedCategories: Binding<Set<CategoryType>>,
    category: CategoryType
  ) {
    self._selectedCategories = selectedCategories
    self.category = category
  }
  
  fileprivate var body: some View {
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
          if selectedCategories.contains(category) {
            selectedCategories.remove(category)
          } else {
            selectedCategories.insert(category)
          }
        }
      
      Text(category.rawValue)
        .font(.r14)
        .foregroundColor(DesignSystem.Colors.grey100)
    }
  }
}

// MARK: - 카테고리 타입 Extension
fileprivate extension CategoryType {
  var defaultIcon: Image {
    switch self {
    case .politics:
      return DesignSystem.Icons.politicsSmall
    case .economic:
      return DesignSystem.Icons.economicSmall
    case .society:
      return DesignSystem.Icons.societySmall
    case .world:
      return DesignSystem.Icons.worldSmall
    case .culture:
      return DesignSystem.Icons.cultureSmall
    case .science:
      return DesignSystem.Icons.scienceSmall
    }
  }
  
  var selectedIcon: Image {
    switch self {
    case .politics:
      return DesignSystem.Icons.selectPoliticsSmall
    case .economic:
      return DesignSystem.Icons.selectEconomicSmall
    case .society:
      return DesignSystem.Icons.selectSocietySmall
    case .world:
      return DesignSystem.Icons.selectWorldSmall
    case .culture:
      return DesignSystem.Icons.selectCultureSmall
    case .science:
      return DesignSystem.Icons.selectScienceSmall
    }
  }
}

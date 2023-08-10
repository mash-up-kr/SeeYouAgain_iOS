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
  private let store: Store<BottomSheetState, BottomSheetAction>
  
  init(store: Store<BottomSheetState, BottomSheetAction>) {
    self.store = store
  }
  
  var body: some View {
    WithViewStore(store, observe: \.mode) { viewStore in
      HStack {
        Text(viewStore.state == .basic ? "관심 키워드를 선택해주세요" : "관심 기업을 선택해주세요")
          .font(.b18)
          .foregroundColor(DesignSystem.Colors.grey100)
        Spacer()
      }
      .padding(.horizontal, 24)
    }
  }
}

struct CategoryBottomSheetContent: View {
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
          ForEach(viewStore.allCategories, id: \.self) { category in
            CategoryItemView(
              store: store.stateless,
              category: category,
              isSelected: viewStore.selectedCategories.contains(category)
            )
          }
        }
      }
      .onAppear { viewStore.send(._fetchMode) }
      .scrollDisabled(true)
      .frame(height: viewStore.state.mode == .basic ? 218 : 452)
    }
  }
}

// MARK: - 카테고리 아이템 뷰
private struct CategoryItemView: View {
  private let store: Store<Void, BottomSheetAction>
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
    store: Store<Void, BottomSheetAction>,
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
          .lineLimit(1)
      }
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
    case .naver:
      return DesignSystem.Icons.naverSmall
    case .kakao:
      return DesignSystem.Icons.kakaoSmall
    case .line:
      return DesignSystem.Icons.lineSmall
    case .coupang:
      return DesignSystem.Icons.coupangSmall
    case .wooah:
      return DesignSystem.Icons.wooahSmall
    case .carrot:
      return DesignSystem.Icons.carrotSmall
    case .toss:
      return DesignSystem.Icons.tossSmall
    case .samsung:
      return DesignSystem.Icons.samsungSmall
    case .hyundai:
      return DesignSystem.Icons.hyundaiSmall
    case .cj:
      return DesignSystem.Icons.cjSmall
    case .korea_gas:
      return DesignSystem.Icons.koreaGasSmall
    case .korea_elec:
      return DesignSystem.Icons.koreaElecSmall
    case .sk_hynics:
      return DesignSystem.Icons.skhynicsSmall
    case .lg_elec:
      return DesignSystem.Icons.lgSmall
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
    case .naver:
      return DesignSystem.Icons.selctNaverSmall
    case .kakao:
      return DesignSystem.Icons.selctKakaoSmall
    case .line:
      return DesignSystem.Icons.selctLineSmall
    case .coupang:
      return DesignSystem.Icons.selctCoupangSmall
    case .wooah:
      return DesignSystem.Icons.selctWooahSmall
    case .carrot:
      return DesignSystem.Icons.selctCarrotSmall
    case .toss:
      return DesignSystem.Icons.selctTossSmall
    case .samsung:
      return DesignSystem.Icons.selctSamsungSmall
    case .hyundai:
      return DesignSystem.Icons.selctHyundaiSmall
    case .cj:
      return DesignSystem.Icons.selctCjSmall
    case .korea_gas:
      return DesignSystem.Icons.selctKoreaGasSmall
    case .korea_elec:
      return DesignSystem.Icons.selctKoreaElecSmall
    case .sk_hynics:
      return DesignSystem.Icons.selctSkhynicsSmall
    case .lg_elec:
      return DesignSystem.Icons.selctLgSmall
    }
  }
}

//
//  SetCategoryView.swift
//  SetCategory
//
//  Created by GREEN on 2023/04/28.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Common
import ComposableArchitecture
import DesignSystem
import SwiftUI

public struct SetCategoryView: View {
  private let store: Store<SetCategoryState, SetCategoryAction>
  
  public init(store: Store<SetCategoryState, SetCategoryAction>) {
    self.store = store
  }
  
  public var body: some View {
    WithViewStore(store) { viewStore in
      VStack(spacing: 0) {
        TitleView()
        
        Spacer()
          .frame(height: 56)
        
        ActiveCategoryGridView(store: store)
        
        Spacer()
          .frame(height: 24)
        
        InActiveCategoryGridView()
        
        Spacer()
        
        BottomButton(
          title: viewStore.bottomButtonTitle,
          disabled: !viewStore.state.isSelectButtonEnabled,
          action: { viewStore.send(.selectButtonTapped) }
        )
        .padding(.bottom, 8)
      }
      .apply(content: { view in
        WithViewStore(store.scope(state: \.toastMessage)) { toastMessageViewStore in
          view.toast(
            text: toastMessageViewStore.state,
            toastType: .warning
          )
        }
      })
    }
    .shortsBackgroundView()
    .navigationBarHidden(true)
  }
}

// MARK: - 타이틀 뷰
private struct TitleView: View {
  fileprivate var body: some View {
    HStack {
      VStack(alignment: .leading, spacing: 4) {
        Text("관심 키워드를 선택해주세요")
          .font(.b20)
          .foregroundColor(DesignSystem.Colors.grey100)
        
        Text("최소 1개 이상 선택해주세요")
          .font(.r13)
          .foregroundColor(DesignSystem.Colors.grey70)
      }
      
      Spacer()
    }
    .padding(.top, 32)
    .padding(.horizontal, 24)
  }
}

// MARK: - 활성화된 카테고리 그리드 뷰
private struct ActiveCategoryGridView: View {
  private let store: Store<SetCategoryState, SetCategoryAction>
  private let columns = [
    GridItem(.flexible()),
    GridItem(.flexible()),
    GridItem(.flexible())
  ]
  
  fileprivate init(store: Store<SetCategoryState, SetCategoryAction>) {
    self.store = store
  }
  
  fileprivate var body: some View {
    WithViewStore(store) { viewStore in
      LazyVGrid(columns: columns, spacing: 24) {
        ForEach(viewStore.state.allCategories, id: \.self) { category in
          CategoryItemView(
            store: store,
            category: category,
            isSelected: viewStore.state.selectedCategories.contains(category)
          )
        }
      }
      .padding(.horizontal, 24)
    }
  }
}

// MARK: - 비활성화된 카테고리 그리드 뷰
private struct InActiveCategoryGridView: View {
  private let columns = [
    GridItem(.flexible()),
    GridItem(.flexible()),
    GridItem(.flexible())
  ]
  private let title: [String?] = ["연예", "스포츠", nil]
  
  fileprivate var body: some View {
    LazyVGrid(columns: columns, spacing: 24) {
      ForEach(title, id: \.self) { title in
        if let title = title {
          VStack(spacing: 8) {
            DesignSystem.Icons.comingSoon
              .frame(width: 98, height: 98)
            
            Text(title)
              .font(.r14)
              .foregroundColor(DesignSystem.Colors.grey70)
          }
        } else {
          EmptyView()
            .frame(width: 98, height: 98)
        }
      }
    }
    .padding(.horizontal, 24)
  }
}

// MARK: - 카테고리 아이템 뷰
private struct CategoryItemView: View {
  private let store: Store<SetCategoryState, SetCategoryAction>
  private var category: CategoryType
  @State private var isSelected: Bool = false
  @State private var isPressed: Bool = false
  private var backgroundColor: Color {
    if isSelected {
      return category.pressedColor
    } else {
      return category.defaultColor
    }
  }
  private var iconImage: Image {
    if isPressed {
      return category.selectedIcon
    } else {
      return category.defaultIcon
    }
  }
  
  fileprivate init(
    store: Store<SetCategoryState, SetCategoryAction>,
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
          .frame(width: 98, height: 98)
          .background(
            Circle()
              .fill(backgroundColor)
          )
          .overlay(
            Circle()
              .stroke(DesignSystem.Colors.white, lineWidth: 0.5)
          )
          .gesture(
            DragGesture(minimumDistance: 0)
              .onChanged { _ in
                isSelected = true
              }
              .onEnded { _ in
                isSelected = false
                isPressed.toggle()
                viewStore.send(.categoryTapped(category))
              }
          )
        
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
  
  var defaultColor: Color {
    return DesignSystem.Colors.white.opacity(0.28)
  }
  
  var pressedColor: Color {
    return DesignSystem.Colors.white.opacity(0.5)
  }
}

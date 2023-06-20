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
          .frame(height: 64)
        
        ActiveCategoryGridView(store: store)
        
        Spacer()
          .frame(height: 26)
        
        InActiveCategoryGridView()
        
        Spacer()
        
        BottomButton(
          title: "선택",
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
      Text("관심 키워드를 선택해주세요")
        .font(.b20)
        .foregroundColor(DesignSystem.Colors.grey100)
      
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
      LazyVGrid(columns: columns, spacing: 16) {
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
    LazyVGrid(columns: columns, spacing: 16) {
      ForEach(title, id: \.self) { title in
        if let title = title {
          VStack(spacing: 6) {
            Text(title)
              .font(.b14)
              .foregroundColor(.black)
            
            Text("Coming soon!")
              .font(.r12)
          }
          .frame(width: 98, height: 98)
          .background(
            Circle()
              .fill(.white.opacity(0.3))
          )
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
  @State private var isSelected: Bool
  
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
      Button(
        action: {
          isSelected.toggle()
          viewStore.send(.categoryTapped(category))
        },
        label: {
          VStack(spacing: 8) {
            Spacer()
              .frame(height: 1)
            
            // TODO: - 추후 디자인이 나오면 해당 이미지로 변경 예정
            Rectangle()
              .fill(.gray)
              .frame(width: 40, height: 40)
            
            Text(category.rawValue)
              .font(.r14)
              .foregroundColor(DesignSystem.Colors.grey90)
          }
          .frame(width: 98, height: 98)
          // TODO: - 추후 선택/미선택에 대한 컬러값 확정 시 변경 예정
          .background(
            isSelected ?
            Circle()
              .fill(.green.opacity(0.64))
            : Circle()
              .fill(.white.opacity(0.64))
          )
          .overlay(
            Circle()
              .stroke(.white, lineWidth: 0.5)
          )
        }
      )
    }
  }
}

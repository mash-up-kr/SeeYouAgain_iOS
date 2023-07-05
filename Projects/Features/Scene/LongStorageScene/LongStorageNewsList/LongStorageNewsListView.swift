//
//  LongStorageNewsListView.swift
//  Scene
//
//  Created by GREEN on 2023/04/28.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Common
import ComposableArchitecture
import DesignSystem
import SwiftUI

public struct LongStorageNewsListView: View {
  private let store: Store<LongStorageNewsListState, LongStorageNewsListAction>
  
  public init(store: Store<LongStorageNewsListState, LongStorageNewsListAction>) {
    self.store = store
  }
  
  public var body: some View {
    WithViewStore(store) { viewStore in
      VStack(spacing: 0) {
        TopNavigationBar(
          title: "오래 간직할 숏스",
          leftIcon: DesignSystem.Icons.iconNavigationLeft,
          leftIconButtonAction: {
            viewStore.send(.backButtonTapped)
          },
          rightText: viewStore.shortsNewsItemsCount == 0 ? nil : (viewStore.state.isInEditMode ? "삭제" : "편집"),
          rightIconButtonAction: {
            if !viewStore.state.isInEditMode {
              viewStore.send(.editButtonTapped)
            } else {
              viewStore.send(.deleteButtonTapped)
            }
          }
        )
        
        ScrollView {
          VStack(spacing: 0) {
            MonthInfoView(
              month: viewStore.state.month,
              shortsCompleteCount: viewStore.state.shortsCompleteCount
            )
            
            Spacer()
              .frame(height: viewStore.state.isInEditMode ? 40 : 48)
            
            // 필터 뷰
            if !viewStore.state.isInEditMode && viewStore.state.shortsNewsItemsCount != 0 {
              HStack {
                SortBottomSheetButton(store: store.scope(state: \.sortType))
                Spacer()
                FilterBottomSheetButton(store: store.scope(state: \.selectedCategories))
              }
              .padding(.horizontal, 24)
              
              Spacer()
                .frame(height: 16)
            }
            
            if viewStore.shortsNewsItemsCount == 0 {
              // 저장한 숏스 없는 경우
              Spacer()
                .frame(height: 128)
              
              Text("아직 저장한 숏스가 없어요\n하루가 지나도 뉴스를 보고싶다면 저장해보세요")
                .multilineTextAlignment(.center)
                .font(.b14)
                .foregroundColor(DesignSystem.Colors.grey70)
                .padding(.horizontal, 24)
            } else {
              ForEachStore(
                self.store.scope(
                  state: \.shortsNewsItems,
                  action: { .shortsNewsItem(id: $0, action: $1) }
                )
              ){
                LongShortsItemView(store: $0)
              }
              .padding(.horizontal, 24)
              .padding(.bottom, 16)
            }
          }
          .frame(maxWidth: .infinity)
        }
        .padding(.bottom, 16)
        .ignoresSafeArea()
      }
      .onAppear {
        viewStore.send(._onAppear)
      }
      .longStorageSortBottomSheet(store: store)
      .filterBottomSheet(store: store)
    }
  }
}

private struct MonthInfoView: View {
  private var month: String
  private var shortsCompleteCount: Int
  
  fileprivate init(
    month: String,
    shortsCompleteCount: Int
  ) {
    self.month = month
    self.shortsCompleteCount = shortsCompleteCount
  }
  
  fileprivate var body: some View {
    VStack(spacing: 8) {
      Spacer()
        .frame(height: 40)
      
      HStack(spacing: 16) {
        Button {
          // TODO: 기준 날짜보다 과거의 데이터 있을 떄에만 버튼 활성화
        } label: {
          DesignSystem.Icons.iconActiveCaretLeft
        }
        
        Text(month)
          .font(.b14)
          .foregroundColor(DesignSystem.Colors.grey90)
        
        Button {
          // TODO: 기준 날짜보다 최근인 데이터 있을 때에만 버튼 활성화
        } label: {
          DesignSystem.Icons.iconActiveCaretRight
        }
      }
      
      Text("\(shortsCompleteCount)숏스")
        .font(.b24)
        .foregroundColor(DesignSystem.Colors.grey100)
    }
  }
}

// 정렬 바텀시트 버튼
private struct SortBottomSheetButton: View {
  private let store: Store<SortType, LongStorageNewsListAction>
  
  fileprivate init(store: Store<SortType, LongStorageNewsListAction>) {
    self.store = store
  }
  
  fileprivate var body: some View {
    WithViewStore(store) { viewStore in
      HStack(spacing: 0) {
        Text(viewStore.state.rawValue)
          .font(.r14)
          .foregroundColor(DesignSystem.Colors.grey70)
        
        DesignSystem.Icons.iconChevronDown
      }
      .onTapGesture { viewStore.send(.showSortBottomSheet) }
    }
  }
}

// 카테고리 필터 바텀시트 버튼
private struct FilterBottomSheetButton: View {
  private let store: Store<Set<CategoryType>, LongStorageNewsListAction>
  
  fileprivate init(store: Store<Set<CategoryType>, LongStorageNewsListAction>) {
    self.store = store
  }
  
  fileprivate var body: some View {
    WithViewStore(store) { viewStore in
      HStack(spacing: 0) {
        Text(buildSelectedCategoriesText(viewStore.state))
          .font(.r14)
          .foregroundColor(DesignSystem.Colors.grey70)
        
        DesignSystem.Icons.iconChevronDown
      }
      .onTapGesture { viewStore.send(.showCategoryFilterBottomSheet) }
    }
  }
    
  private func buildSelectedCategoriesText(_ selectedCategories: Set<CategoryType>) -> String {
    if selectedCategories.isEmpty || selectedCategories.count == CategoryType.allCases.count {
      return "전체"
    } else {
      return selectedCategories
        .map { $0.rawValue }
        .joined(separator: "•")
    }
  }
}

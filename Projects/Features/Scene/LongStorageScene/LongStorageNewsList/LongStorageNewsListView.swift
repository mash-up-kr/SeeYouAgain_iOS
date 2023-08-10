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
          title: "개별 뉴스",
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
            MonthInfoView(store: store)
            
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
              
              Text("아직 저장한 개별 뉴스가 없어요.\n뉴스 오른쪽 상단의 저장을 눌러 저장할 수 있어요.")
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
      .loading(viewStore.state.isLoading)
      .onAppear {
        viewStore.send(._viewWillAppear)
      }
      .onDisappear {
        viewStore.send(._onDisappear)
      }
      .apply(content: { view in
        WithViewStore(store.scope(state: \.successToastMessage)) { successToastMessageViewStore in
          view.toast(
            text: successToastMessageViewStore.state,
            toastType: .info
          )
        }
      })
      .apply(content: { view in
        WithViewStore(store.scope(state: \.failureToastMessage)) { failureToastMessageViewStore in
          view.toast(
            text: failureToastMessageViewStore.state,
            toastType: .warning
          )
        }
      })
      .longStorageSortBottomSheet(store: store)
      .filterBottomSheet(store: store)
      .dateFilterBottomSheet(store: store)
    }
  }
}

private struct MonthInfoView: View {
  private let store: Store<LongStorageNewsListState, LongStorageNewsListAction>
  
  fileprivate init(store: Store<LongStorageNewsListState, LongStorageNewsListAction>) {
    self.store = store
  }
  
  fileprivate var body: some View {
    WithViewStore(store) { viewStore in
      VStack(spacing: 8) {
        Spacer()
          .frame(height: 40)
        
        HStack(spacing: 16) {
          Button {
            viewStore.send(.minusMonthButtonTapped)
          } label: {
            DesignSystem.Icons.iconActiveCaretLeft
          }
          
          DateFilterButton(store: store.scope(state: \.dateType))

          Button {
            viewStore.send(.plusMonthButtonTapped)
          } label: {
            viewStore.state.isCurrentMonth
            ? DesignSystem.Icons.iconInactiveCaretRight : DesignSystem.Icons.iconActiveCaretRight
          }
          .disabled(viewStore.state.isCurrentMonth)
        }
        
        Text("\(viewStore.state.shortsNewsItemsCount)숏스")
          .font(.b24)
          .foregroundColor(DesignSystem.Colors.grey100)
      }
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
    let sortedSelectedCategories = selectedCategories.sorted(by: CategoryType.compare)
    if sortedSelectedCategories.isEmpty || sortedSelectedCategories.count == CategoryType.allCases.count {
      return "전체"
    } else {
      return sortedSelectedCategories
        .map { $0.rawValue }
        .joined(separator: "•")
    }
  }
}

private struct DateFilterButton: View {
  private let store: Store<DateType, LongStorageNewsListAction>
  
  fileprivate init(store: Store<DateType, LongStorageNewsListAction>) {
    self.store = store
  }
  
  fileprivate var body: some View {
    WithViewStore(store) { viewStore in
      HStack(spacing: 0) {
        Text("\(String(viewStore.state.year))년 \(viewStore.state.month)월")
          .underline(true, color: DesignSystem.Colors.grey90)
          .font(.b14)
          .foregroundColor(DesignSystem.Colors.grey90)
          .onTapGesture {
            viewStore.send(.showDateFilterBottomSheet)
          }
      }
    }
  }
}

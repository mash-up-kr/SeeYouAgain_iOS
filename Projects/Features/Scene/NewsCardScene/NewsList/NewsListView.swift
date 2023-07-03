//
//  NewsListView.swift
//  Scene
//
//  Created by GREEN on 2023/04/28.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Common
import ComposableArchitecture
import DesignSystem
import SwiftUI

public struct NewsListView: View {
  private let store: Store<NewsListState, NewsListAction>
  
  public init(store: Store<NewsListState, NewsListAction>) {
    self.store = store
  }
  
  public var body: some View {
    WithViewStore(store) { viewStore in
      ZStack {
        VStack(spacing: 0) {
          TopNavigationBar(
            leftIcon: DesignSystem.Icons.iconNavigationLeft,
            leftIconButtonAction: {
              viewStore.send(.backButtonTapped)
            }
          )
          
          ScrollView {
            VStack(spacing: 0) {
              Spacer()
                .frame(height: 30)
              
              Text(viewStore.keywordTitle)
                .font(.b24)
                .foregroundColor(DesignSystem.Colors.grey100)
                .padding(.horizontal, 24)
                .lineLimit(3)
              
              Spacer()
                .frame(height: 48)
              
              FilterView(store: store.scope(state: \.sortType))
              .padding(.horizontal, 24)
              
              Spacer()
                .frame(height: 16)
              
              ForEachStore(
                self.store.scope(
                  state: \.newsItems,
                  action: { .newsItem(id: $0, action: $1) }
                )
              ) {
                NewsCardView(store: $0)
              }
              .padding(.horizontal, 24)
              .padding(.bottom, 16)
            }
          }
          .padding(.bottom, 48)
        }
        .onAppear {
          viewStore.send(._onAppear)
        }
        
        VStack(spacing: 0) {
          Spacer()
          
          BottomButton(title: "다 읽었어요") {
            viewStore.send(.completeButtonTapped)
          }
        }
      }
      .bottomSheet(
        isPresented: viewStore.binding(
          get: \.sortBottomSheetState.isPresented,
          send: { .sortBottomSheet(._setIsPresented($0)) }
        ),
        headerArea: { NewsListSortBottomSheetHeader() },
        content: {
          NewsListSortBottomSheetContent(
            store: store.scope(
              state: \.sortBottomSheetState,
              action: NewsListAction.sortBottomSheet
            )
          )
        },
        bottomArea: {
          NewsListSortBottomSheetFooter(
            store: store.scope(
              state: \.sortBottomSheetState,
              action: NewsListAction.sortBottomSheet
            )
            .stateless
          )
        }
      )
    }
  }
}

private struct FilterView: View {
  private let store: Store<SortType, NewsListAction>
  
  fileprivate init(store: Store<SortType, NewsListAction>) {
    self.store = store
  }
  
  fileprivate var body: some View {
    WithViewStore(store) { viewStore in
      HStack(spacing: 0) {
        Text(viewStore.state.rawValue)
          .font(.r14)
          .foregroundColor(DesignSystem.Colors.grey70)
        
        DesignSystem.Icons.iconChevronDown
        
        Spacer()
      }
      .onTapGesture {
        viewStore.send(.showSortBottomSheet)
      }
    }
  }
}

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
              newsListCount: viewStore.state.shortsNewsItemsCount
            )
            
            Spacer()
              .frame(height: viewStore.state.isInEditMode ? 40 : 48)
            
            // 필터 뷰
            if !viewStore.state.isInEditMode && viewStore.state.shortsNewsItemsCount != 0 {
              FilterView(store: store.scope(state: \.sortType))
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
        viewStore.send(._viewWillAppear)
      }
      .bottomSheet(
        isPresented: viewStore.binding(
          get: \.sortBottomSheetState.isPresented,
          send: { .sortBottomSheet(._setIsPresented($0)) }
        ),
        headerArea: { LongStorageSortBottomSheetHeader() },
        content: {
          LongStorageSortBottomSheetContent(
            store: store.scope(
              state: \.sortBottomSheetState,
              action: LongStorageNewsListAction.sortBottomSheet
            )
          )
        },
        bottomArea: {
          LongStorageSortBottomSheetFooter(
            store: store.scope(
              state: \.sortBottomSheetState,
              action: LongStorageNewsListAction.sortBottomSheet
            )
            .stateless
          )
        }
      )
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
    }
  }
}

private struct MonthInfoView: View {
  private var month: String
  private var newsListCount: Int
  
  fileprivate init(
    month: String,
    newsListCount: Int
  ) {
    self.month = month
    self.newsListCount = newsListCount
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
      
      Text("\(newsListCount)숏스")
        .font(.b24)
        .foregroundColor(DesignSystem.Colors.grey100)
    }
  }
}

private struct FilterView: View {
  private let store: Store<SortType, LongStorageNewsListAction>
  
  fileprivate init(store: Store<SortType, LongStorageNewsListAction>) {
    self.store = store
  }
  
  fileprivate var body: some View {
    WithViewStore(store) { viewStore in
      VStack(spacing: 0) {
        HStack(spacing: 0) {
          Group {
            Text(viewStore.state.rawValue)
              .font(.r14)
              .foregroundColor(DesignSystem.Colors.grey70)
            
            DesignSystem.Icons.iconChevronDown
          }
          .onTapGesture {
            viewStore.send(.showSortBottomSheet)
          }
          
          Spacer()
          
          Group {
            Text("전체")
              .font(.r14)
              .foregroundColor(DesignSystem.Colors.grey70)
            
            DesignSystem.Icons.iconChevronDown
          }
        }
        .padding(.horizontal, 24)
        
        Spacer()
          .frame(height: 16)
      }
    }
  }
}

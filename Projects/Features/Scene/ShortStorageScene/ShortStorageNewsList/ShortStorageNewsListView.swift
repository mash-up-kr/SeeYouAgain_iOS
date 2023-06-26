//
//  ShortStorageNewsListView.swift
//  Scene
//
//  Created by GREEN on 2023/04/28.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import ComposableArchitecture
import DesignSystem
import SwiftUI

public struct ShortStorageNewsListView: View {
  private let store: Store<ShortStorageNewsListState, ShortStorageNewsListAction>
  
  public init(store: Store<ShortStorageNewsListState, ShortStorageNewsListAction>) {
    self.store = store
  }
  
  public var body: some View {
    WithViewStore(store) { viewStore in
      VStack(spacing: 0) {
        TopNavigationBar(
          title: "오늘의 숏스",
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
            TodayInfoView(
              today: viewStore.today,
              shortsCompleteCount: viewStore.shortsCompleteCount
            )
            
            if viewStore.shortsNewsItemsCount == 0 {
              // 오늘 저장한 숏스 없는 경우
              EmptyNewsContentView(
                shortsNewsItemsCount: viewStore.shortsNewsItemsCount,
                shortsCompleteCount: viewStore.shortsCompleteCount,
                message: "오늘은 아직 저장한 뉴스가 없어요\n뉴스를 보고 마음에 드면 저장해보세요"
              )
            } else if viewStore.shortsCompleteCount == viewStore.shortsNewsItemsCount {
              // 오늘 저장한 숏스 다 읽은 경우
              EmptyNewsContentView(
                shortsNewsItemsCount: viewStore.shortsNewsItemsCount,
                shortsCompleteCount: viewStore.shortsCompleteCount,
                message: "오늘 저장한 뉴스를 다 읽었어요!"
              )
            } else {
              Spacer()
                .frame(height: 16)
              
              HStack(spacing: 4) {
                Group {
                  Text("남은시간")
                    .font(.r16)
                  
                  Text(viewStore.state.remainTimeString)
                    .font(.b16)
                }
                .foregroundColor(DesignSystem.Colors.blue200)
                
                Button {
                  // TODO: 안내 사항 표시
                } label: {
                  DesignSystem.Icons.iconSuggestedCircle
                    .frame(width: 16, height: 16)
                }
              }
              
              Spacer()
                .frame(height: 48)
              
              ForEachStore(
                self.store.scope(
                  state: \.shortsNewsItems,
                  action: { .shortsNewsItem(id: $0, action: $1) }
                )
              ) {
                TodayShortsItemView(store: $0)
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
    }
  }
}

private struct TodayInfoView: View {
  private var today: String
  private var shortsCompleteCount: Int
  
  fileprivate init(
    today: String,
    shortsCompleteCount: Int
  ) {
    self.today = today
    self.shortsCompleteCount = shortsCompleteCount
  }
  
  var body: some View {
    VStack(spacing: 0) {
      Spacer()
        .frame(height: 40)
      
      Text(today)
        .font(.b14)
        .foregroundColor(DesignSystem.Colors.grey90)
        .padding(.horizontal, 105)
      
      Spacer()
        .frame(height: 8)
      
      Text("\(shortsCompleteCount)숏스")
        .font(.b24)
        .foregroundColor(
          shortsCompleteCount == 0 ? DesignSystem.Colors.grey60 : DesignSystem.Colors.grey100
        )
        .padding(.horizontal, 24)
    }
  }
}

private struct EmptyNewsContentView: View {
  private var shortsNewsItemsCount: Int
  private var shortsCompleteCount: Int
  private var message: String
  
  fileprivate init(
    shortsNewsItemsCount: Int,
    shortsCompleteCount: Int,
    message: String
  ) {
    self.shortsNewsItemsCount = shortsNewsItemsCount
    self.shortsCompleteCount = shortsCompleteCount
    self.message = message
  }
  
  var body: some View {
    VStack(spacing: 0) {
      Spacer()
        .frame(height: 128)
      
      Text(message)
        .multilineTextAlignment(.center)
        .font(.b14)
        .foregroundColor(DesignSystem.Colors.grey70)
        .padding(.horizontal, 24)
    }
  }
}

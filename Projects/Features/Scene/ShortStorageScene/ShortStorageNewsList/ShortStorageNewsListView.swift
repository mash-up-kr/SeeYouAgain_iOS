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
          title: "키워드별 뉴스",
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
            // 현재 저장한 뉴스 키워드가 없는 경우
            if viewStore.shortsNewsItemsCount == 0 {
              EmptyNewsContentView(
                shortsNewsItemsCount: viewStore.shortsNewsItemsCount,
                message: "아직 저장한 뉴스 키워드가  없어요.\n홈에서 편지를 내리면 저장할 수 있어요."
              )
            } else {
              Spacer()
                .frame(height: 16)

              ForEachStore(
                self.store.scope(
                  state: \.shortsNewsItems,
                  action: { .shortsNewsItem(id: $0, action: $1) }
                )
              ) { store in
                WithViewStore(store) { viewStore in
                  TodayShortsItemView(store: store)
                    .onAppear {
                      if viewStore.state.isLastItem {
                        viewStore.send(._fetchMoreItems(viewStore.state.id))
                      }
                    }
                }
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
    }
  }
}

private struct EmptyNewsContentView: View {
  private var shortsNewsItemsCount: Int
  private var message: String
  
  fileprivate init(
    shortsNewsItemsCount: Int,
    message: String
  ) {
    self.shortsNewsItemsCount = shortsNewsItemsCount
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

// MARK: - Tooltip View
private struct TooltipView: View {
  private let store: Store<ShortStorageNewsListState, ShortStorageNewsListAction>
  
  fileprivate init(store: Store<ShortStorageNewsListState, ShortStorageNewsListAction>) {
    self.store = store
  }
  
  fileprivate var body: some View {
    WithViewStore(store) { viewStore in
      // TriangleShape으로 사각형 가려야해서, 겹치도록 spcing 마이너스로 설정
      VStack(spacing: -6) {
        ZStack {
          // 산 모양 라인
          trianglePathView
            .padding(.leading, 117)

          // 아래 네모칸 윗부분 일정 부분 가리기 위한 삼각형
          TriangleShape()
            .frame(width: 20, height: 15)
            .padding(.leading, 117)
            .padding(.bottom, -2) // 산모양 라인이랑 겹치지 않게 하기 위해 내려와있음
            .foregroundColor(.white)
        }
        .frame(width: 20, height: 15)
        .zIndex(1)
        
        tooltipContentView
      }
    }
  }
  
  private var trianglePathView: some View {
    Path { path in
      path.move(to: CGPoint(x: 0, y: 15))
      path.addLine(to: CGPoint(x: 7.5, y: 2))
      path.addQuadCurve(to: CGPoint(x: 12.5, y: 2), control: CGPoint(x: 10, y: 0))
      path.addLine(to: CGPoint(x: 20, y: 15))
    }
    .stroke(DesignSystem.Colors.grey80, lineWidth: 1)
  }
  
  private var tooltipContentView: some View {
    WithViewStore(store) { viewStore in
      ZStack {
        Rectangle()
          .foregroundColor(.white)
          .frame(width: 282, height: 83)
          .cornerRadius(8)
          .overlay(
            RoundedRectangle(cornerRadius: 8)
              .stroke(DesignSystem.Colors.grey80, lineWidth: 1)
          )
        
        HStack(alignment: .top, spacing: 8) {
          Text("‘오늘의 숏스’는 자정이 지나면 사라져요. 오늘 안에 읽고, 오늘이 지나도 보고 싶은 숏스는 ‘오래 간직할 숏스'로 옮겨보세요.")
            .font(.r14)
            .foregroundColor(DesignSystem.Colors.grey80)
          
          Button {
            viewStore.send(.tooltipButtonTapped)
          } label: {
            DesignSystem.Icons.iconX
              .frame(width: 16, height: 16)
          }
        }
        .frame(width: 246, alignment: .topLeading)
      }
      .frame(width: 282, height: 94)
    }
  }
}

private struct TriangleShape: Shape {
  fileprivate func path(in rect: CGRect) -> Path {
    var path = Path()
    
    path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
    path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
    path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
    path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
    
    return path
  }
}

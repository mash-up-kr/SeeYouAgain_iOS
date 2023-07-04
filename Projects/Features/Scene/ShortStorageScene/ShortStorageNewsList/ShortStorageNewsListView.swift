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
                    .monospacedDigit()
                }
                .foregroundColor(DesignSystem.Colors.blue200)
                
                Button {
                  viewStore.send(.tooltipButtonTapped)
                } label: {
                  DesignSystem.Icons.iconSuggestedCircle
                    .frame(width: 16, height: 16)
                }
              }

              if viewStore.state.isDisplayTooltip {
                TooltipView(store: store)
                  .padding(.leading, 20)
                  .padding(.bottom, -55) // VStack 내부에서 겹치게 하기 위해서 마이너스로 설정
                  .zIndex(1) // 스크롤 할 때 같이 내려가야해서 VStack에 넣고, 맨 위에 겹치도록 zIndex 설정
              } else {
                Spacer()
                  .frame(height: 48)
              }
             
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
        viewStore.send(._viewWillAppear)
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
            .padding(.leading, 115)

          // 아래 네모칸 윗부분 일정 부분 가리기 위한 삼각형
          TriangleShape()
            .frame(width: 20, height: 15)
            .padding(.leading, 115)
            .padding(.bottom, -2) // 산모양 라인이랑 겹치지 않게 하기 위해 내려와있음
            .foregroundColor(.white)
        }
        .frame(width: 20, height: 15)
        .zIndex(1)
        
        toolTipContentView
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
  
  private var toolTipContentView: some View {
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

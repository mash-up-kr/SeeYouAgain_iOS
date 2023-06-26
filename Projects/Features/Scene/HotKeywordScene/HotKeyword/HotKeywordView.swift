//
//  HotKeywordView.swift
//  Scene
//
//  Created by GREEN on 2023/04/28.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import ComposableArchitecture
import DesignSystem
import SwiftUI

// lina-TODO: 1. 써클 tap API 연동 작업(값 넘기기), 2. 디자인 검수: 써클 블러, 쪼꼬미 원 추가
public struct HotKeywordView: View {
  private let store: Store<HotKeywordState, HotKeywordAction>
  
  public init(store: Store<HotKeywordState, HotKeywordAction>) {
    self.store = store
  }
  
  // lina-TODO: 여기 값들 스토어로?
  @Namespace var leadingID
  @State private var offset: CGFloat = UIScreen.main.bounds.width
  private let keyWindow = UIApplication.shared.connectedScenes
    .compactMap { $0 as? UIWindowScene }
    .flatMap { $0.windows }
    .first { $0.isKeyWindow }
  private var screenWidth: CGFloat {
    UIScreen.main.bounds.width
  }
  private var bubbleViewIdealHeight: CGFloat {
    let topSafearea = keyWindow?.safeAreaInsets.top ?? 0
    let bottomSafearea = keyWindow?.safeAreaInsets.bottom ?? 0
    let titleViewHeight: CGFloat = 100
    let tabberHeight: CGFloat = 82
    return UIScreen.main.bounds.height - (topSafearea + bottomSafearea + titleViewHeight + tabberHeight)
  }
  public var basicOffset: CGFloat {
    return screenWidth - screenWidth / 4
  }

  public var body: some View {
    WithViewStore(store) { viewStore in
      ScrollView(.vertical, showsIndicators: false) {
        titleView
        
        bubbleChartScrollView
        
        // 하단 탭바 높이만큼 여백
        Spacer()
          .frame(height: 82)
      }
      .background(DesignSystem.Colors.blue50)
      .refreshable {
        offset = basicOffset
        viewStore.send(.pullToRefresh)
      }
      .onAppear {
        offset = basicOffset
        viewStore.send(._fetchData)
      }
    }
    .navigationBarHidden(true)
    .apply(content: { view in
      WithViewStore(store.scope(state: \.toastMessage)) { toastMessage in
        view.toast(
          text: toastMessage.state,
          toastType: .warning,
          toastOffset: -100
        )
      }
    })
  }
  
  private var titleView: some View {
    WithViewStore(store) { viewStore in
      VStack(spacing: 4) {
        HStack(spacing: 10) {
          DesignSystem.Icons.hotkeywordTitle
          Spacer()
        }
        .frame(height: 32)
        
        HStack {
          Text("\(viewStore.subTitleText) 기준")
            .font(.r13)
            .foregroundColor(DesignSystem.Colors.grey70)
            .frame(height: 16)
          Spacer()
        }
      }
      .padding(.vertical, 24)
      .padding(.horizontal, 24)
    }
  }
  
  // MARK: - Buuble Chart
  private var bubbleChartScrollView: some View {
    WithViewStore(store) { viewStore in
      ScrollViewReader { proxy in
        GeometryReader { geometry in
          ScrollView(.horizontal, showsIndicators: false) {
            HStack {
              scrollObservableView
                .id(leadingID)
              
              BubbleChartView(
                offset: $offset,
                hotKeywordPointList: viewStore.hotKeywordPointList,
                action: { viewStore.send(.hotKeywordCircleTapped) }
              )
              .frame(
                width: geometry.size.height * 1.5,
                height: geometry.size.height
              )
            }
            .onPreferenceChange(ScrollOffsetKey.self) { value in
              offset = value
            }
          }
        }
        .frame(
          idealWidth: screenWidth,
          idealHeight: bubbleViewIdealHeight
        )
        .onChange(of: viewStore.isRefresh) { isRefresh in
          if isRefresh == true {
            offset = basicOffset
            viewStore.send(._setIsRefreshFalse)
            withAnimation {
              proxy.scrollTo(leadingID, anchor: .topLeading)
            }
          }
        }
      }
    }
  }
}

// MARK: - BubbleChartView
extension HotKeywordView {
  private struct BubbleChartView: View {
    @Binding var offset: CGFloat
    var hotKeywordPointList: HotKeywordPointList
    var action: () -> Void

    var body: some View {
      GeometryReader { geometry in
        ForEach(hotKeywordPointList.pointList, id: \.self) { point in
          BubbleView(
            keyword: point.keyword,
            bubbleSize: point.size,
            bubbleColor: point.color,
            geometryHeight: geometry.size.height,
            pointX: point.x * geometry.size.width,
            offset: $offset,
            action: action
          )
          .offset(
            x: point.x * geometry.size.width,
            y: point.y * geometry.size.height
          )
        }
      }
    }
  }
}

// MARK: - 스크롤 관련
extension HotKeywordView {
  private var scrollObservableView: some View {
    GeometryReader { geometry in
      let offsetX = -geometry.frame(in: .global).origin.x
      Color.clear
        .preference(
          key: ScrollOffsetKey.self,
          value: offsetX
        )
    }
    .frame(width: 0)
  }
  
  private struct ScrollOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = .zero
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
      value += nextValue()
    }
  }
}

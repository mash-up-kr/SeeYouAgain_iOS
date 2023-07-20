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

public struct HotKeywordView: View {
  private let store: Store<HotKeywordState, HotKeywordAction>
  
  public init(store: Store<HotKeywordState, HotKeywordAction>) {
    self.store = store
  }
  
  @Namespace var leadingID
  
  @State private var offset: CGFloat = 0
  
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
    screenWidth * 2 / 3
  }
  
  public var body: some View {
    WithViewStore(store) { viewStore in
      ScrollView(.vertical, showsIndicators: false) {
        titleView
        
        bubbleChartScrollView
          .allowsHitTesting(viewStore.isAllowHitTest)

        // 하단 탭바 높이만큼 여백
        Spacer()
          .frame(height: 82)
      }
      .background(DesignSystem.Colors.blue50)
      .refreshable {
        offset = 0
        viewStore.send(.pullToRefresh)
      }
      .onAppear {
        if viewStore.isFirstLoading {
          viewStore.send(._fetchData)
        } else {
          offset = viewStore.currentOffset == .zero ? basicOffset : viewStore.currentOffset
        }
      }
      .onDisappear {
        viewStore.send(._setCurrentOffset(offset + basicOffset))
      }
      .onChange(of: viewStore.isFirstLoading) { isFirstLoading in
        if isFirstLoading == false {
          offset = basicOffset
        }
      }
      .onAppCameToForeground {
        viewStore.send(.backToForeground)
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
          Text(viewStore.subTitleText)
            .font(.r13)
            .foregroundColor(DesignSystem.Colors.grey70)
            .frame(height: 16)
          Spacer()
        }
      }
      .padding(24)
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
              
              GeometryReader { geometry in
                ForEach(viewStore.hotKeywordPointList.pointList, id: \.self) { hotKeywordPoint in
                  BubbleView(
                    hotKeywordPoint: hotKeywordPoint,
                    geometryHeight: geometry.size.height,
                    pointX: hotKeywordPoint.x * geometry.size.width,
                    offset: $offset,
                    action: { viewStore
                      .send(
                        .hotKeywordCircleTapped(
                          hotKeywordPoint.keyword,
                          currentOffset: offset + basicOffset
                        )
                      )
                    }
                  )
                  .offset(
                    x: hotKeywordPoint.x * geometry.size.width,
                    y: hotKeywordPoint.y * geometry.size.height
                  )
                }
              }
              .frame(
                width: geometry.size.height * 1.5,
                height: geometry.size.height
              )
            }
            .onPreferenceChange(ScrollOffsetKey.self) { value in
              offset = value
              if offset > 0 {
                viewStore.send(._setIsScrollToLeading(false))
              }
            }
          }
        }
        .frame(
          idealWidth: screenWidth,
          idealHeight: bubbleViewIdealHeight
        )
        .onChange(of: viewStore.isRefresh) { isRefresh in
          if isRefresh {
            withAnimation {
              proxy.scrollTo(leadingID, anchor: .topLeading)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
              offset = basicOffset
              viewStore.send(._setIsRefresh(false))
            }
          }
        }
        .onChange(of: viewStore.isScrollToLeading) { canScrollToLeading in
          if canScrollToLeading {
            withAnimation {
              proxy.scrollTo(leadingID, anchor: .topLeading)
            }
          }
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

fileprivate extension View {
  func onAppCameToForeground(perform action: @escaping () -> Void) -> some View {
    self.onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
      action()
    }
  }
}

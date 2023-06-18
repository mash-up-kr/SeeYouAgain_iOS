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

// TODO: 1.API 연동 작업, 2.써클 tap, 3. 써클 블러, 4. 디자인 검수(써클 패턴 묘하게 안맞는거 확인 해야할듯, 쪼꼬미 원 추가)
// 5. 패턴 추가, 6. 진입했을때 애니메이션 시작하기, 7. 리프레시 컨트롤 및, 시작시 데이터 받아오기(패턴 랜덤화), 8. 클릭시 액션
public struct HotKeywordView: View {
  private let store: Store<HotKeywordState, HotKeywordAction>
  
  public init(store: Store<HotKeywordState, HotKeywordAction>) {
    self.store = store
  }
  
  @Namespace var leadingID

  // TODO: 여기 값들 전부 스토어로 넘길 수 있을까?
  @State private var offset: CGFloat = UIScreen.main.bounds.width
  @State private var isRefresh: Bool = false // 사용안함
  
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
    let titleViewHeight: CGFloat = 98
    let tabberHeight: CGFloat = 82
    return UIScreen.main.bounds.height - (topSafearea + bottomSafearea + titleViewHeight + tabberHeight)
  }
  
  public var body: some View {
    WithViewStore(store) { viewStore in
      ScrollView(.vertical, showsIndicators: false) {
        titleView
        
        bubbleChartView
        
        // 하단 탭바 높이만큼 여백
        Spacer()
          .frame(height: 82)
      }
      .background(DesignSystem.Colors.blue50)
      .refreshable {
        offset = screenWidth - screenWidth / 4
        isRefresh = true

        viewStore.send(._pullToRefresh)
      }
    }
    .navigationBarHidden(true)
  }
  
  private var titleView: some View {
    WithViewStore(store) { viewStore in
      VStack(spacing: 4) {
        HStack(spacing: 10) {
          // TODO: title 이미지 변경, 불꽃 이미지 교체
          DesignSystem.Icons.hotkeywordTitle
          DesignSystem.Icons.hotkeywordFire
          Spacer()
        }
        .frame(height: 30)
        
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
  private var bubbleChartView: some View {
    WithViewStore(store) { viewStore in
      ScrollViewReader { proxy in
        GeometryReader { geometry in
          ScrollView(.horizontal, showsIndicators: false) {
            HStack {
              scrollObservableView
                .id(leadingID)
              
              BubbleChartView(
                hotKeyword: viewStore.hotKeywordPointList,
                offset: $offset
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
        .onChange(of: isRefresh) { isRefresh in
          if isRefresh == true {
            withAnimation { // TODO: 애니메이션 여부 체크
              proxy.scrollTo(leadingID, anchor: .topLeading)
            }
            self.isRefresh.toggle()
          }
        }
      }
    }
  }
  
  struct BubbleChartView: View {
    var hotKeyword: HotKeywordPointList
    @Binding var offset: CGFloat {
      didSet {
        print(offset)
      }
    }
    
    var body: some View {
      GeometryReader { geometry in
        ForEach(hotKeyword.pointList, id: \.self) { point in
          BubbleView(
            keyword: point.keyword,
            bubbleSize: point.size,
            bubbleColor: point.color,
            geometryHeight: geometry.size.height,
            pointX: point.x * geometry.size.width,
            offset: $offset
          )
          .offset(
            x: point.x * geometry.size.width,
            y: point.y * geometry.size.height
          )
        }
      }
    }
  }
  
  // MARK: - 스크롤 관련
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
  
  struct ScrollOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = .zero
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
      value += nextValue()
    }
  }
}

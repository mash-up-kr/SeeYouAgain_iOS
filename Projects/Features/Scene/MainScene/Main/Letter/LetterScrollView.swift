//
//  LetterScrollView.swift
//  Main
//
//  Created by 김영균 on 2023/06/13.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

struct LetterScrollView: View {
  private enum Constant {
    static let defaultLetterWidth: CGFloat = 280
    static let defaultLetterHeight: CGFloat = 378
    static let iphone13MiniWidth: CGFloat = 375
    static let iphone13MiniHeight: CGFloat = 812
  }
  
  private let store: Store<LetterScrollState, LetterScrollAction>
  private let deviceRatio: CGSize
  private let letterSize: CGSize
  private let letterSpacing: CGFloat
  private let leadingOffset: CGFloat
  
  init(store: Store<LetterScrollState, LetterScrollAction>) {
    self.store = store
    
    let screenSize = UIScreen.main.bounds
    self.deviceRatio = CGSize(
      width: screenSize.width / Constant.iphone13MiniWidth,
      height: screenSize.height / Constant.iphone13MiniHeight
    )
    self.letterSize = CGSize(
      width: Constant.defaultLetterWidth * deviceRatio.width,
      height: Constant.defaultLetterHeight * deviceRatio.height
    )
    self.letterSpacing = (screenSize.width - letterSize.width) / 5
    self.leadingOffset = (screenSize.width - letterSize.width) / 2
  }
  
  var body: some View {
    WithViewStore(store) { viewStore in
      GeometryReader { _ in
        LazyHStack(alignment: .center, spacing: letterSpacing) {
          // TODO: API 연결 후 해야하는 작업
          // 뉴스 데이터로 바꾸기
          ForEach(0..<5) { index in
            LetterView(
              isFold: viewStore.binding(
                get: \.isFolded[index],
                send: { LetterScrollAction._setIsFolded(index, $0) }
              ),
              deviceRatio: deviceRatio
            )
            .frame(width: letterSize.width)
            .offset(viewStore.offsets[index])
            .rotationEffect(.degrees(viewStore.degrees[index]))
            .animation(.easeInOut, value: viewStore.currentScrollOffset)
          }
        }
        .frame(height: letterSize.height)
      }
      .onAppear {
        viewStore.send(
          ._onAppear(
            .init(
              size: letterSize,
              spacing: letterSpacing,
              leadingOffset: leadingOffset
            )
          )
        )
      }
      .offset(x: viewStore.currentScrollOffset, y: 0)
      .simultaneousGesture(
        DragGesture()
          .onChanged { value in
            viewStore.send(.dragOnChanged(value.translation))
          }
          .onEnded { _ in
            viewStore.send(._countPageIndex)
            viewStore.send(.dragOnEnded)
          }
      )
    }
  }
}

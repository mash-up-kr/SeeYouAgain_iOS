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
  private let store: Store<LetterScrollState, LetterScrollAction>
  
  init(store: Store<LetterScrollState, LetterScrollAction>) {
    self.store = store
  }
  
  var body: some View {
    WithViewStore(store) { viewStore in
      GeometryReader { _ in
        LazyHStack(alignment: .center, spacing: viewStore.layout.spacing) {
          // TODO: API 연결 후 해야하는 작업
          // 뉴스 데이터로 바꾸기
          ForEach(0..<5) { index in
            LetterView(
              isFold: viewStore.binding(
                get: \.isFolded[index],
                send: { LetterScrollAction._setIsFolded(index, $0) }
              ),
              deviceRatio: viewStore.layout.ratio
            )
            .frame(width: viewStore.layout.size.width)
            .offset(viewStore.offsets[index])
            .rotationEffect(.degrees(viewStore.degrees[index]))
            .animation(.easeInOut, value: viewStore.currentScrollOffset)
          }
        }
        .frame(height: viewStore.layout.size.height)
      }
      .onAppear {
        viewStore.send(._onAppear)
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

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
          NewsCardsView(store: store)
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

private struct NewsCardsView: View {
  private var store: Store<LetterScrollState, LetterScrollAction>
  
  init(store: Store<LetterScrollState, LetterScrollAction>) {
    self.store = store
  }
  
  var body: some View {
    WithViewStore(store) { viewStore in
      ForEach(viewStore.state.newsCards.indices, id: \.self) { id in
        NewsCardView(
          store: store.scope(
            state: \.newsCards[id],
            action: { .newsCard(id: id, action: $0) }
          )
        )
        .frame(width: viewStore.state.layout.size.width)
        .offset(viewStore.state.offsets[id])
        .rotationEffect(.degrees(viewStore.state.degrees[id]))
        .animation(.easeInOut, value: viewStore.state.currentScrollOffset)
      }
    }
  }
}

//
//  NewsCardScrollView.swift
//  Main
//
//  Created by 김영균 on 2023/06/13.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

struct NewsCardScrollView: View {
  private let store: Store<NewsCardScrollState, NewsCardScrollAction>
  
  init(store: Store<NewsCardScrollState, NewsCardScrollAction>) {
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
      .onChange(
        of: viewStore.newsCards,
        perform: { newValue in
          viewStore.send(.newsCardsChanged)
        }
      )
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
  private var store: Store<NewsCardScrollState, NewsCardScrollAction>
  
  fileprivate init(store: Store<NewsCardScrollState, NewsCardScrollAction>) {
    self.store = store
  }
  
  fileprivate var body: some View {
    WithViewStore(store) { viewStore in
      ForEach(viewStore.newsCards.indices, id: \.self) { id in
        NewsCardView(
          store: store.scope(
            state: \.newsCards[id],
            action: { .newsCard(id: id, action: $0) }
          )
        )
        .frame(width: viewStore.layout.size.width)
        .offset(viewStore.offsets[id])
        .rotationEffect(.degrees(viewStore.degrees[id]))
        .animation(.easeInOut, value: viewStore.currentScrollOffset)
      }
    }
  }
}

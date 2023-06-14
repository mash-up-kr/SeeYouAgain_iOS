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
    static let defaultItemWidth: CGFloat = 280
    static let iphone13MiniWidth: CGFloat = 375
    static let iphone13MiniHeight: CGFloat = 812
  }
  
  private let store: Store<LetterScrollState, LetterScrollAction>
  private let screenWidth: CGFloat
  private let itemWidth: CGFloat
  private let itemPadding: CGFloat
  private let leadingOffset: CGFloat
  
  init(store: Store<LetterScrollState, LetterScrollAction>) {
    self.store = store
    self.screenWidth = UIScreen.main.bounds.width
    let screenRatio = screenWidth / Constant.iphone13MiniWidth
    self.itemWidth = Constant.defaultItemWidth * screenRatio
    self.itemPadding = 10
    self.leadingOffset = (screenWidth - itemWidth) / 2
  }
  
  var body: some View {
    WithViewStore(store) { viewStore in
      GeometryReader { _ in
        LazyHStack(alignment: .center, spacing: itemPadding) {
          ForEach(0..<5) { index in
            Rectangle()
              .frame(width: itemWidth)
              .offset(viewStore.offsets[index])
              .rotationEffect(.degrees(viewStore.degrees[index]))
              .animation(.easeInOut, value: viewStore.gestureDragOffset)
          }
        }
      }
      .onAppear { sendOnAppearActions(to: viewStore) }
      .offset(x: viewStore.currentScrollOffset, y: 0)
      .simultaneousGesture(
        DragGesture()
          .onChanged { value in
            sendDragChangedActions(to: viewStore, with: value)
          }
          .onEnded { value in
            let newPageIndex = countPageIndex(for: viewStore.currentScrollOffset, itemsAmount: 5)
            sendDragEndedActions(to: viewStore, pageIndex: newPageIndex)
          }
      )
    }
  }
}

private extension LetterScrollView {
  func sendOnAppearActions(
    to viewStore: ViewStore<LetterScrollState, LetterScrollAction>
  ) {
    viewStore.send(._setCurrentScrollOffset(leadingOffset))
    viewStore.send(._calculateDegrees(itemWidth))
    viewStore.send(._calculateOffsets(itemWidth))
  }
  
  func sendDragChangedActions(
    to viewStore: ViewStore<LetterScrollState, LetterScrollAction>,
    with value: DragGesture.Value
  ) {
    viewStore.send(.dragOnChanged(value.translation))
    viewStore.send(._countCurrentScrollOffset(leadingOffset, itemWidth + itemPadding))
    viewStore.send(._calculateDegrees(itemWidth))
    viewStore.send(._calculateOffsets(itemWidth))
  }
  
  func sendDragEndedActions(
    to viewStore: ViewStore<LetterScrollState, LetterScrollAction>,
    pageIndex: Int
  ) {
    viewStore.send(._setGestureDragOffset(.zero))
    viewStore.send(._setCurrentPageIndex(pageIndex))
    viewStore.send(._countCurrentScrollOffset(leadingOffset, itemWidth + itemPadding))
    viewStore.send(._calculateDegrees(itemWidth))
    viewStore.send(._calculateOffsets(itemWidth))
  }
  
  func countPageIndex(for offset: CGFloat, itemsAmount: Int) -> Int {
    guard itemsAmount > 0 else { return 0 }
    let logicalOffset = (offset - leadingOffset ) * -1.0
    let floatIndex = (logicalOffset) / (itemWidth + itemPadding)
    let index = Int(round(floatIndex))
    return min(max(index, 0), itemsAmount - 1)
  }
}

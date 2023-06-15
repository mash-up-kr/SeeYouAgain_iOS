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
  private let letterPadding: CGFloat
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
    self.letterPadding = (screenSize.width - letterSize.width) / 5
    self.leadingOffset = (screenSize.width - letterSize.width) / 2
  }
  
  var body: some View {
    WithViewStore(store) { viewStore in
      GeometryReader { _ in
        LazyHStack(alignment: .center, spacing: letterPadding) {
          ForEach(0..<5) { index in
            LetterView(deviceRatio: deviceRatio)
              .frame(width: letterSize.width)
              .offset(viewStore.offsets[index])
              .rotationEffect(.degrees(viewStore.degrees[index]))
              .animation(.easeInOut, value: viewStore.gestureDragOffset)
          }
        }
        .frame(height: letterSize.height)
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
    viewStore.send(._calculateDegrees(letterSize.width))
    viewStore.send(._calculateOffsets(letterSize.width))
  }
  
  func sendDragChangedActions(
    to viewStore: ViewStore<LetterScrollState, LetterScrollAction>,
    with value: DragGesture.Value
  ) {
    viewStore.send(.dragOnChanged(value.translation))
    viewStore.send(._countCurrentScrollOffset(leadingOffset, letterSize.width + letterPadding))
    viewStore.send(._calculateDegrees(letterSize.width))
    viewStore.send(._calculateOffsets(letterSize.width))
  }
  
  func sendDragEndedActions(
    to viewStore: ViewStore<LetterScrollState, LetterScrollAction>,
    pageIndex: Int
  ) {
    viewStore.send(._setGestureDragOffset(.zero))
    viewStore.send(._setCurrentPageIndex(pageIndex))
    viewStore.send(._countCurrentScrollOffset(leadingOffset, letterSize.width + letterPadding))
    viewStore.send(._calculateDegrees(letterSize.width))
    viewStore.send(._calculateOffsets(letterSize.width))
  }
  
  func countPageIndex(for offset: CGFloat, itemsAmount: Int) -> Int {
    guard itemsAmount > 0 else { return 0 }
    let logicalOffset = (offset - leadingOffset ) * -1.0
    let floatIndex = (logicalOffset) / (letterSize.width + letterPadding)
    let index = Int(round(floatIndex))
    return min(max(index, 0), itemsAmount - 1)
  }
}

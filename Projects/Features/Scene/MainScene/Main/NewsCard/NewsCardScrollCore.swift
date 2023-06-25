//
//  NewsCardScrollCore.swift
//  Main
//
//  Created by 김영균 on 2023/06/13.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import ComposableArchitecture
import Foundation
import Models

public struct NewsCardLayout: Equatable {
  var ratio: CGSize = .zero
  var size: CGSize = .zero
  var spacing: CGFloat = 0
  var leadingOffset: CGFloat = 0
}

public struct NewsCardScrollState: Equatable {
  var gestureDragOffset: CGFloat
  var currentScrollOffset: CGFloat
  var previousScrollIndex: Int
  var currentScrollIndex: Int
  var layout: NewsCardLayout
  var newsCards: IdentifiedArrayOf<NewsCardState>
  var degrees: [Double]
  var offsets: [CGSize]
  
  init(
    layout: NewsCardLayout,
    newsCards: IdentifiedArrayOf<NewsCardState>
  ) {
    self.gestureDragOffset = 0
    self.currentScrollOffset = 0
    self.previousScrollIndex = 0
    self.currentScrollIndex = 0
    self.layout = layout
    self.newsCards = newsCards
    self.degrees = Array(repeating: 0, count: newsCards.count)
    self.offsets = Array(repeating: .zero, count: newsCards.count)
  }
}

public enum NewsCardScrollAction {
  // MARK: - User Action
  case dragOnChanged(CGSize)
  case dragOnEnded
  case newsCardsChanged
  
  // MARK: - Inner Business Action
  case _onAppear
  case _countScrollIndex
  case _countCurrentScrollOffset
  case _updateIsFolds
  case _calculateDegrees
  case _calculateOffsets
  case _fetchNewsCardsIfNeeded(Int, Int)
  case _concatenateNewsCards([NewsCard])
  
  // MARK: - Inner SetState Action
  case _setDegrees([Double])
  case _setOffsets([CGSize])
  case _setGestureDragOffset(CGFloat)
  case _setCurrentScrollOffset(CGFloat)
  case _setScrollIndex(Int)
  
  // MARK: - Child Action
  case newsCard(id: Int, action: NewsCardAction)
}

public struct NewsCardScrollEnvironmnet {}

public let newsCardScrollReducer = Reducer<
  NewsCardScrollState,
  NewsCardScrollAction,
  NewsCardScrollEnvironmnet
>.combine(
  newsCardReducer
    .forEach(
      state: \.newsCards,
      action: /NewsCardScrollAction.newsCard(id:action:),
      environment: { _ in NewsCardEnvironment() }
    ),
  Reducer { state, action, environment in
    switch action {
    case let .dragOnChanged(translation):
      return Effect.concatenate(
        Effect(value: ._setGestureDragOffset(translation.width)),
        Effect(value: ._countCurrentScrollOffset),
        Effect(value: ._calculateDegrees),
        Effect(value: ._calculateOffsets)
      )
      
    case .dragOnEnded:
      return Effect.concatenate(
        Effect(value: ._setGestureDragOffset(.zero)),
        Effect(value: ._countCurrentScrollOffset),
        Effect(value: ._updateIsFolds),
        Effect(value: ._calculateDegrees),
        Effect(value: ._calculateOffsets)
      )
      
    case .newsCardsChanged:
      return Effect.concatenate(
        Effect(value: ._countCurrentScrollOffset),
        Effect(value: ._updateIsFolds),
        Effect(value: ._calculateDegrees),
        Effect(value: ._calculateOffsets)
      )
      
    case ._onAppear:
      if state.newsCards.isEmpty {
        return .none
      }
      return Effect.concatenate(
        Effect(value: ._countCurrentScrollOffset),
        Effect(value: .newsCard(id: 0, action: ._setIsFolded(false))),
        Effect(value: ._calculateDegrees),
        Effect(value: ._calculateOffsets)
      )
      
    case ._countScrollIndex:
      guard !state.newsCards.isEmpty else { return .none }
      let logicalOffset = (state.currentScrollOffset - state.layout.leadingOffset) * -1.0
      let contentWidth = state.layout.size.width + state.layout.spacing
      let floatIndex = (logicalOffset) / contentWidth
      let intIndex = Int(round(floatIndex))
      let newPageIndex = min(max(intIndex, 0), state.newsCards.count - 1)
      return Effect.concatenate(
        Effect(value: ._setScrollIndex(newPageIndex)),
        Effect(value: ._fetchNewsCardsIfNeeded(newPageIndex, state.newsCards.count))
      )
      
    case ._countCurrentScrollOffset:
      let contentWidth = state.layout.size.width + state.layout.spacing
      let activePageOffset = CGFloat(state.currentScrollIndex) * contentWidth
      let scrollOffset = state.layout.leadingOffset - activePageOffset + state.gestureDragOffset
      return Effect(value: ._setCurrentScrollOffset(scrollOffset))
      
    case ._updateIsFolds:
      return Effect.concatenate(
        Effect(value: .newsCard(id: state.previousScrollIndex, action: ._setIsFolded(true))),
        Effect(value: .newsCard(id: state.currentScrollIndex, action: ._setIsFolded(false)))
      )
      
    case ._calculateDegrees:
      let updateDegrees = calculateDegrees(state, newsCardWidth: state.layout.size.width)
      return Effect(value: ._setDegrees(updateDegrees))
      
    case ._calculateOffsets:
      let updateOffsets = calculateOffsets(state, newsCardWidth: state.layout.size.width)
      return Effect(value: ._setOffsets(updateOffsets))
      
    case let ._setDegrees(degrees):
      state.degrees = degrees
      return .none
      
    case let ._setOffsets(offsets):
      state.offsets = offsets
      return .none
      
    case let ._setGestureDragOffset(dragOffset):
      state.gestureDragOffset = dragOffset
      return .none
      
    case let ._setCurrentScrollOffset(scrollOffset):
      state.currentScrollOffset = scrollOffset
      return .none
      
    case let ._setScrollIndex(pageIndex):
      state.previousScrollIndex = state.currentScrollIndex
      state.currentScrollIndex = pageIndex
      return .none
      
    case ._fetchNewsCardsIfNeeded:
      return .none
      
    case let ._concatenateNewsCards(newsCards):
      concatenateNewsCards(&state, source: newsCards)
      return .none
      
    case let .newsCard(id, action):
      return .none
    }
  }
)

private func calculateDegrees(
  _ state: NewsCardScrollState,
  newsCardWidth: CGFloat
) -> [Double] {
  let rotationDegree: Double = 11.0
  let slope = rotationDegree / newsCardWidth
  let gestureDragOffset = state.gestureDragOffset
  let yOffset = rotationDegree
  
  return state.degrees.indices.map { index in
    switch state.currentScrollIndex {
    case let pageIndex where pageIndex > index:
      let weight = min(2.0, Double(pageIndex - index))
      return slope * gestureDragOffset - weight * yOffset
      
    case let pageIndex where pageIndex == index:
      return slope * gestureDragOffset
      
    case let pageIndex where pageIndex < index:
      let weight = min(2.0, Double(index - pageIndex))
      return slope * gestureDragOffset + weight * yOffset
      
    default:
      return 0.0
    }
  }
}

private func calculateOffsets(
  _ state: NewsCardScrollState,
  newsCardWidth: CGFloat
) -> [CGSize] {
  let distance: Double = 25.0
  let slope = distance / newsCardWidth
  let gestureDragOffset = state.gestureDragOffset
  let yOffset = distance
  
  return state.offsets.indices.map { index in
    switch state.currentScrollIndex {
    case let pageIndex where pageIndex > index:
      let weight = min(2.0, Double(pageIndex - index))
      return CGSize(
        width: slope * gestureDragOffset - weight * yOffset,
        height: -slope * gestureDragOffset + weight * yOffset
      )
      
    case let pageIndex where pageIndex == index:
      let sign: Double = (gestureDragOffset > 0 ? 1.0 : -1.0)
      return CGSize(
        width: slope * gestureDragOffset,
        height: sign * slope * gestureDragOffset
      )
      
    case let pageIndex where pageIndex < index:
      let weight = min(2.0, Double(index - pageIndex))
      return CGSize(
        width: slope * gestureDragOffset + weight * yOffset,
        height: slope * gestureDragOffset + weight * yOffset
      )
      
    default:
      return CGSize(width: 0, height: 0)
    }
  }
}

private func concatenateNewsCards(
  _ state: inout NewsCardScrollState,
  source newsCards: [NewsCard]
) {
  let size = state.newsCards.count
  newsCards.enumerated().forEach { index, card in
    state.degrees.append(0)
    state.offsets.append(.zero)
    state.newsCards.append(
      NewsCardState(
        index: size + index - 1,
        newsCard: card,
        layout: state.layout,
        isFolded: true
      )
    )
  }
}

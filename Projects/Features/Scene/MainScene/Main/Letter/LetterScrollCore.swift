//
//  LetterScrollCore.swift
//  Main
//
//  Created by 김영균 on 2023/06/13.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import ComposableArchitecture
import Foundation
import Models

public struct LetterLayout: Equatable {
  var ratio: CGSize
  var size: CGSize
  var spacing: CGFloat
  var leadingOffset: CGFloat
}

public struct LetterScrollState: Equatable {
  var layout: LetterLayout
  var gestureDragOffset: CGFloat = 0
  var currentScrollOffset: CGFloat = 0
  var previousPageIndex: Int = 0
  var currentPageIndex: Int = 0
  
  // TODO: API 연결 후 해야하는 작업
  // 모델로 교체
  var newsCards: IdentifiedArrayOf<NewsCardState>
  var degrees: [Double]
  var offsets: [CGSize]
  
  init(
       layout: LetterLayout,
    letters: [NewsCard]
  ) {
    self.layout = layout
    // TODO: API 연결 후 해야하는 작업
    // 데이터에 따라 배열 길이 변경
    self.newsCards = IdentifiedArray(
      uniqueElements: letters.enumerated().map{ index, newscard in
        NewsCardState(index: index, newsCard: newscard, layout: layout, isFolded: true)
      }
    )
    self.degrees = Array(repeating: 0, count: letters.count)
    self.offsets = Array(repeating: .zero, count: letters.count)
  }
}

public enum LetterScrollAction {
  // MARK: - User Action
  case dragOnChanged(CGSize)
  case dragOnEnded
  
  // MARK: - Inner Business Action
  case _onAppear
  case _countPageIndex
  case _countCurrentScrollOffset
  case _updateIsFolds
  case _calculateDegrees
  case _calculateOffsets
  
  // MARK: - Inner SetState Action
  case _setDegrees([Double])
  case _setOffsets([CGSize])
  case _setGestureDragOffset(CGFloat)
  case _setCurrentScrollOffset(CGFloat)
  case _setPageIndex(Int)
  
  // MARK: - Child Action
  case newsCard(id: Int, action: NewsCardAction)
  
}

public struct LetterScrollEnvironmnet {}

public let letterScrollReducer = Reducer<
  LetterScrollState,
  LetterScrollAction,
  LetterScrollEnvironmnet
>.combine(
  newsCardReducer
    .forEach(
      state: \.newsCards,
      action: /LetterScrollAction.newsCard(id:action:),
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
      
    case ._countPageIndex:
      guard !state.newsCards.isEmpty else { return .none }
      let logicalOffset = (state.currentScrollOffset - state.layout.leadingOffset) * -1.0
      let contentWidth = state.layout.size.width + state.layout.spacing
      let floatIndex = (logicalOffset) / contentWidth
      let intIndex = Int(round(floatIndex))
      let newPageIndex = min(max(intIndex, 0), state.newsCards.count - 1)
      return Effect(value: ._setPageIndex(newPageIndex))
      
    case ._countCurrentScrollOffset:
      let contentWidth = state.layout.size.width + state.layout.spacing
      let activePageOffset = CGFloat(state.currentPageIndex) * contentWidth
      let scrollOffset = state.layout.leadingOffset - activePageOffset + state.gestureDragOffset
      return Effect(value: ._setCurrentScrollOffset(scrollOffset))
      
    case ._updateIsFolds:
      return Effect.concatenate(
        Effect(value: .newsCard(id: state.previousPageIndex, action: ._setIsFolded(true))),
        Effect(value: .newsCard(id: state.currentPageIndex, action: ._setIsFolded(false)))
      )
      
    case ._calculateDegrees:
      let updateDegrees = calculateDegrees(state, letterWidth: state.layout.size.width)
      return Effect(value: ._setDegrees(updateDegrees))
      
    case ._calculateOffsets:
      let updateOffsets = calculateOffsets(state, letterWidth: state.layout.size.width)
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
      
    case let ._setPageIndex(pageIndex):
      state.previousPageIndex = state.currentPageIndex
      state.currentPageIndex = pageIndex
      return .none
      
    case let .newsCard(id, action):
      return .none
    }
  }
)

private func calculateDegrees(
  _ state: LetterScrollState,
  letterWidth: CGFloat
) -> [Double] {
  let rotationDegree: Double = 11.0
  let slope = rotationDegree / letterWidth
  let gestureDragOffset = state.gestureDragOffset
  let yOffset = rotationDegree
  
  return state.degrees.indices.map { index in
    switch state.currentPageIndex {
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
  _ state: LetterScrollState,
  letterWidth: CGFloat
) -> [CGSize] {
  let distance: Double = 25.0
  let slope = distance / letterWidth
  let gestureDragOffset = state.gestureDragOffset
  let yOffset = distance
  
  return state.offsets.indices.map { index in
    switch state.currentPageIndex {
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

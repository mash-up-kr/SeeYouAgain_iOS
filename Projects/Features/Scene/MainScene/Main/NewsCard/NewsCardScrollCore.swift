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
import Services

public enum DragDirection: Equatable {
  case none
  case horizontal
  case vertical
}

public struct NewsCardLayout: Equatable {
  var ratio: CGSize = .zero
  var size: CGSize = .zero
  var spacing: CGFloat = 0
  var leadingOffset: CGFloat = 0
}

public struct NewsCardScrollState: Equatable {
  var dragDirection: DragDirection
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
    self.dragDirection = .none
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
  case dragOnEnded(CGSize)
  
  // MARK: - Inner Business Action
  case _onAppear
  case _calculateScrollIndex
  case _calculateCurrentScrollOffset
  case _updateIsFolds
  case _calculateDegrees
  case _calculateOffsets
  case _fetchNewsCardsIfNeeded(Int, Int)
  case _concatenateNewsCards([NewsCard])
  
  // MARK: - Inner SetState Action
  case _setDragDirection(DragDirection)
  case _setGestureDragOffset(CGFloat)
  case _setCurrentScrollOffset(CGFloat)
  case _setScrollIndex(Int)
  
  // MARK: - Child Action
  case newsCard(id: Int, action: NewsCardAction)
}

public struct NewsCardScrollEnvironmnet {
  fileprivate let mainQueue: AnySchedulerOf<DispatchQueue>
  fileprivate let newsCardService: NewsCardService
  
  public init(
    mainQueue: AnySchedulerOf<DispatchQueue>,
    newsCardService: NewsCardService) {
      self.mainQueue = mainQueue
      self.newsCardService = newsCardService
    }
}

public let newsCardScrollReducer = Reducer<
  NewsCardScrollState,
  NewsCardScrollAction,
  NewsCardScrollEnvironmnet
>.combine(
  newsCardReducer
    .forEach(
      state: \.newsCards,
      action: /NewsCardScrollAction.newsCard(id:action:),
      environment: { NewsCardEnvironment(newsCardService: $0.newsCardService) }
    ),
  Reducer { state, action, environment in
    switch action {
    case let .dragOnChanged(translation):
      switch state.dragDirection {
      case .none:
        let horizontalScroll = abs(translation.width)
        let verticalScroll = abs(translation.height)
        return Effect(value: ._setDragDirection(horizontalScroll > verticalScroll ? .horizontal : .vertical))
        
      case .horizontal:
        return Effect.concatenate(
          Effect(value: ._setGestureDragOffset(translation.width)),
          Effect(value: ._calculateCurrentScrollOffset),
          Effect(value: ._calculateDegrees),
          Effect(value: ._calculateOffsets)
        )
      case .vertical:
        return Effect(value: .newsCard(id: state.currentScrollIndex, action: .dragOnChanged(translation)))
      }
      
    case let .dragOnEnded(translation):
      switch state.dragDirection {
      case .none:
        return .none
        
      case .horizontal:
        return Effect.concatenate(
          Effect(value: ._setDragDirection(.none)),
          Effect(value: ._setGestureDragOffset(.zero)),
          Effect(value: ._calculateCurrentScrollOffset),
          Effect(value: ._updateIsFolds),
          Effect(value: ._calculateDegrees),
          Effect(value: ._calculateOffsets)
        )
      case .vertical:
        return Effect.concatenate(
          Effect(value: ._setDragDirection(.none)),
          Effect(value: .newsCard(id: state.currentScrollIndex, action: .dragOnEnded(translation)))
        )
      }
      
    case ._onAppear:
      if state.newsCards.isEmpty {
        return .none
      }
      return Effect.concatenate(
        Effect(value: ._calculateCurrentScrollOffset),
        Effect(value: .newsCard(id: 0, action: ._setIsFolded(false))),
        Effect(value: ._calculateDegrees),
        Effect(value: ._calculateOffsets)
      )
      
    case ._calculateScrollIndex:
      guard !state.newsCards.isEmpty else { return .none }
      let logicalOffset = (state.currentScrollOffset - state.layout.leadingOffset) * -1.0
      let contentWidth = state.layout.size.width + state.layout.spacing
      let floatIndex = (logicalOffset) / contentWidth
      let intIndex = Int(round(floatIndex))
      let newPageIndex = min(max(intIndex, 0), state.newsCards.count - 1)
      return Effect(value: ._setScrollIndex(newPageIndex))
      
    case ._calculateCurrentScrollOffset:
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
      calculateDegrees(&state, newsCardWidth: state.layout.size.width)
      return .none
      
    case ._calculateOffsets:
      calculateOffsets(&state, newsCardWidth: state.layout.size.width)
      return .none
      
    case let ._setDragDirection(direction):
      state.dragDirection = direction
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
      
    case .newsCard(id: _, action: ._handleSaveNewsCardResponse(.success)):
      return scrollToNextCard(state)
      
    case let .newsCard(id, action):
      return .none
    }
  }
)

private func scrollToNextCard(_ state: NewsCardScrollState) -> Effect<NewsCardScrollAction, Never> {
  let currentScrollIndex = state.currentScrollIndex
  let nextScrollIndex = currentScrollIndex + 1
  let newsCardsCount = state.newsCards.count
  
  // 0부터 오른쪽 화면의 위치까지 5번에 나눠서 스크롤 액션을 발생시킨다.
  // 만약 다음 카드가 없으면 저장 후 이전 카드로 돌아가게한다.
  let scrollWidth = state.layout.size.width
  let hop = scrollWidth / 5
  let scrollRange = stride(
    from: 0,
    to: nextScrollIndex >= newsCardsCount ? scrollWidth : -scrollWidth,
    by: nextScrollIndex >= newsCardsCount ? hop : -hop
  )
  return .run { send in
    // 좌우 드래그 방향을 세팅한다.
    await send(._setDragDirection(.horizontal))
    // 자연스럽게 스크롤이 넘어가는 것처럼 보이기위해 임의로 드래그 이벤트 발생시킨다.
    for width in scrollRange {
      await send(.dragOnChanged(CGSize(width: width, height: 0)))
    }
    await send(._calculateScrollIndex)
    await send(._fetchNewsCardsIfNeeded(nextScrollIndex, newsCardsCount))
    await send(.dragOnEnded(CGSize(width: -scrollWidth, height: 0)))
  }
}

private func calculateCurrentScrollOffset(_ state: NewsCardScrollState) -> CGFloat {
  let contentWidth = state.layout.size.width + state.layout.spacing
  let activePageOffset = CGFloat(state.currentScrollIndex) * contentWidth
  let scrollOffset = state.layout.leadingOffset - activePageOffset + state.gestureDragOffset
  return scrollOffset
}

private func calculateDegrees(
  _ state: inout NewsCardScrollState,
  newsCardWidth: CGFloat
) {
  let rotationDegree: Double = 11.0
  let slope = rotationDegree / newsCardWidth
  let gestureDragOffset = state.gestureDragOffset
  let yOffset = rotationDegree
  
  let calculateRange = state.currentScrollIndex - 2...state.currentScrollIndex + 2
  for index in calculateRange where 0..<state.newsCards.count ~= index {
    switch state.currentScrollIndex {
    case let pageIndex where pageIndex > index:
      let weight = min(2.0, Double(pageIndex - index))
      state.degrees[index] = slope * gestureDragOffset - weight * yOffset
      
    case let pageIndex where pageIndex == index:
      state.degrees[index] = slope * gestureDragOffset
      
    case let pageIndex where pageIndex < index:
      let weight = min(2.0, Double(index - pageIndex))
      state.degrees[index] = slope * gestureDragOffset + weight * yOffset
    
    default:
      state.degrees[index] = 0.0
    }
  }
}

private func calculateOffsets(
  _ state: inout NewsCardScrollState,
  newsCardWidth: CGFloat
) {
  let distance: Double = 25.0
  let slope = distance / newsCardWidth
  let gestureDragOffset = state.gestureDragOffset
  let yOffset = distance
  
  let calculateRange = state.currentScrollIndex - 2...state.currentScrollIndex + 2
  for index in calculateRange where 0..<state.newsCards.count ~= index {
    switch state.currentScrollIndex {
    case let pageIndex where pageIndex > index:
      let weight = min(2.0, Double(pageIndex - index))
      state.offsets[index] = CGSize(
        width: slope * gestureDragOffset - weight * yOffset,
        height: -slope * gestureDragOffset + weight * yOffset
      )
      
    case let pageIndex where pageIndex == index:
      let sign: Double = (gestureDragOffset > 0 ? 1.0 : -1.0)
      state.offsets[index] = CGSize(
        width: slope * gestureDragOffset,
        height: sign * slope * gestureDragOffset
      )
      
    case let pageIndex where pageIndex < index:
      let weight = min(2.0, Double(index - pageIndex))
      state.offsets[index] = CGSize(
        width: slope * gestureDragOffset + weight * yOffset,
        height: slope * gestureDragOffset + weight * yOffset
      )
      
    default:
      state.offsets[index] = CGSize(width: 0, height: 0)
    }
  }
}

private func concatenateNewsCards(
  _ state: inout NewsCardScrollState,
  source newsCards: [NewsCard]
) {
  let offset = state.newsCards.count
  newsCards.enumerated().forEach { index, card in
    state.degrees.append(0)
    state.offsets.append(.zero)
    state.newsCards.append(
      NewsCardState(
        index: offset + index - 1,
        newsCard: card,
        layout: state.layout,
        isFolded: true
      )
    )
  }
}

//
//  LetterScrollCore.swift
//  Main
//
//  Created by 김영균 on 2023/06/13.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import ComposableArchitecture
import Foundation

public struct LetterScrollState: Equatable {
  var gestureDragOffset: CGFloat = 0
  var currentScrollOffset: CGFloat = 0
  var currentPageIndex: Int = 0
  
  var degrees: [Double]
  var offsets: [CGSize]
  
  init() {
    // 임시로 5개
    self.degrees = Array(repeating: 0, count: 5)
    self.offsets = Array(repeating: .zero, count: 5)
  }
}

public enum LetterScrollAction {
  // MARK: - User Action
  case dragOnChanged(CGSize)
  
  // MARK: - Inner Business Action
  case _countCurrentScrollOffset(CGFloat, CGFloat)
  case _calculateDegrees(CGFloat)
  case _calculateOffsets(CGFloat)
  
  // MARK: - Inner SetState Action
  case _setDegrees([Double])
  case _setOffsets([CGSize])
  case _setGestureDragOffset(CGFloat)
  case _setCurrentScrollOffset(CGFloat)
  case _setCurrentPageIndex(Int)
}

public struct LetterScrollEnvironmnet {}

public let letterScrollReducer: Reducer<
  LetterScrollState,
  LetterScrollAction,
  LetterScrollEnvironmnet
> = Reducer { state, action, environment in
  switch action {
  case let .dragOnChanged(translation):
    return Effect(value: ._setGestureDragOffset(translation.width))
    
  case let ._countCurrentScrollOffset(leadingOffset, itemWidth):
    let activePageOffset = CGFloat(state.currentPageIndex) * itemWidth
    let scrollOffset = leadingOffset - activePageOffset + state.gestureDragOffset
    return Effect(value: ._setCurrentScrollOffset(scrollOffset))
    
  case let ._calculateDegrees(letterWidth):
    let updateDegrees = calculateDegrees(state, letterWidth: letterWidth)
    return Effect(value: ._setDegrees(updateDegrees))
    
  case let ._calculateOffsets(letterWidth):
    let updateOffsets = calculateOffsets(state, letterWidth: letterWidth)
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
    
  case let ._setCurrentPageIndex(pageIndex):
    state.currentPageIndex = pageIndex
    return .none
  }
}

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

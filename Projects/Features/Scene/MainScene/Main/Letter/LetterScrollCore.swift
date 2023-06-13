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
  
  var rotateDegrees: [Double]
  var offsets: [CGSize]
  
  init() {
    // 임시로 5개
    self.rotateDegrees = Array(repeating: 0, count: 5)
    self.offsets = Array(repeating: .zero, count: 5)
  }
}

public enum LetterScrollAction {
  case dragOnChanged(CGSize)
  
  case _countCurrentScrollOffset(CGFloat, CGFloat)
  case _calculateRotateDegrees(CGFloat)
  case _calculateOffsets(CGFloat)
  
  case _setRotateDegrees([Double])
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
    
  case let ._calculateRotateDegrees(screenWidth):
    let slope: Double = 11.0 / screenWidth
    let gestureDragOffset = state.gestureDragOffset
    let yOffset: Double = 11.0
    let updateDegrees = state.rotateDegrees.indices.map { index in
      switch state.currentPageIndex {
      case let pageIndex where pageIndex > index:
        return slope * gestureDragOffset - 11.0
        
      case let pageIndex where pageIndex == index:
        return slope * gestureDragOffset
        
      case let pageIndex where pageIndex < index:
        return slope * gestureDragOffset + 11.0
        
      default:
        return 0.0
      }
    }
    return Effect(value: ._setRotateDegrees(updateDegrees))
    
  case let ._calculateOffsets(screenWidth):
    let slope: Double = 25.0 / screenWidth
    let gestureDragOffset = state.gestureDragOffset
    let yOffset: Double = 25.0
    let updateOffsets = state.offsets.indices.map { index in
      switch state.currentPageIndex {
      case let pageIndex where pageIndex > index:
        return CGSize(
          width: slope * gestureDragOffset - yOffset,
          height: -slope * gestureDragOffset + yOffset
        )
        
      case let pageIndex where pageIndex == index:
        let sign: Double = (gestureDragOffset > 0 ? 1.0 : -1.0)
        return CGSize(
          width: slope * gestureDragOffset,
          height: sign * slope * gestureDragOffset
        )
        
      case let pageIndex where pageIndex < index:
        return CGSize(
          width: slope * gestureDragOffset + yOffset,
          height: slope * gestureDragOffset + yOffset
        )
        
      default:
        return CGSize(width: 0, height: 0)
      }
    }
    return Effect(value: ._setOffsets(updateOffsets))
    
  case let ._setRotateDegrees(degrees):
    state.rotateDegrees = degrees
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

//
//  NewsCardCore.swift
//  Main
//
//  Created by 김영균 on 2023/06/21.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import ComposableArchitecture
import Foundation
import Models
import Services

public struct NewsCardState: Equatable, Identifiable {
  public var index: Int
  var newsCard: NewsCard
  var layout: NewsCardLayout
  var isFolded: Bool
  
  public var id: Int { self.index }
}

public enum NewsCardAction {
  // MARK: User Action
  case dragGestureEnded(CGSize)
  
  // MARK: - Inner Business Action
  case _saveNewsCard
  case _handleSaveNewsCardResponse(Result<VoidResponse?, Error>)
  
  // MARK: Inner SetState Action
  case _setIsFolded(Bool)
}

public struct NewsCardEnvironment {
  fileprivate let newsCardService: NewsCardService
  
  public init(newsCardService: NewsCardService) {
    self.newsCardService = newsCardService
  }
}

public let newsCardReducer = Reducer<
  NewsCardState,
  NewsCardAction,
  NewsCardEnvironment
> { state, action, env in
  switch action {
  case let .dragGestureEnded(translation):
    if isDraggedVertically(state: state, with: translation) {
      return Effect(value: ._saveNewsCard)
    }
    return .none
    
  case ._saveNewsCard:
    return env.newsCardService.saveNewsCard(state.newsCard.id)
      .catchToEffect(NewsCardAction._handleSaveNewsCardResponse)
    
  case let ._setIsFolded(folded):
    state.isFolded = folded
    return .none
    
  default:
    return .none
  }
}

private func isDraggedVertically(
  state: NewsCardState,
  with translation: CGSize
) -> Bool {
  let verticalThreshold: CGFloat = state.layout.size.height * 0.3 // 드래그가 수직으로 인식되는 임계값
  let horizontalThresholdRange: Range<Int> = 0..<1 // X축으로 인식하지 않을 임계값
  
  let verticalMovement = translation.height
  let horizontalMovement = abs(translation.width)
  
  return verticalMovement > verticalThreshold && horizontalThresholdRange ~= Int(horizontalMovement)
}

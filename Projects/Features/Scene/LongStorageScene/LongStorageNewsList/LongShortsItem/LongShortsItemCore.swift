//
//  LongShortsItemCore.swift
//  LongStorageNewsList
//
//  Created by 안상희 on 2023/06/25.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import ComposableArchitecture

public struct LongShortsItemState: Equatable, Identifiable {
  public var id: Int
  var isInEditMode: Bool
  var isSelected: Bool
  var cardState: LongShortsCardState
  var isLastItem: Bool = false
  
  public init(
    id: Int,
    isInEditMode: Bool,
    isSelected: Bool,
    cardState: LongShortsCardState
  ) {
    self.id = id
    self.isInEditMode = isInEditMode
    self.isSelected = isSelected
    self.cardState = cardState
  }
}

public enum LongShortsItemAction: Equatable {
  // MARK: - User Action
  case itemSelected // 체크마크 선택
  case itemTapped // 뉴스 카드 선택
  
  // MARK: - Inner Business Action
  case _shortsItemSelectionChanged
  case _fetchMoreItems(String)
  
  // MARK: - Inner SetState Action
  
  // MARK: - Child Action
  case cardAction(LongShortsCardAction)
}

public struct LongShortsItemEnvironment {
  public init() {}
}

public let longShortsItemReducer = Reducer<
  LongShortsItemState,
  LongShortsItemAction,
  LongShortsItemEnvironment
>.combine([
  longShortsCardReducer
    .pullback(
      state: \LongShortsItemState.cardState,
      action: /LongShortsItemAction.cardAction,
      environment: { _ in
        LongShortsCardEnvironment()
      }
    ),
  Reducer { state, action, env in
    switch action {
    case ._shortsItemSelectionChanged:
      state.isSelected.toggle()
      return .none
      
    default: return .none
    }
  }
])

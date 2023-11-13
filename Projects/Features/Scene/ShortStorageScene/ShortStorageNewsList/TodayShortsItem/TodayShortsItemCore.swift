//
//  TodayShortsItemCore.swift
//  ShortStorageNewsList
//
//  Created by 안상희 on 2023/06/18.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import ComposableArchitecture

public struct TodayShortsItemState: Equatable, Identifiable {
  public var id: Int
  var isInEditMode: Bool
  var isSelected: Bool
  var cardState: TodayShortsCardState
  var isLastItem: Bool = false
  
  public init(
    id: Int,
    isInEditMode: Bool,
    isSelected: Bool,
    cardState: TodayShortsCardState
  ) {
    self.id = id
    self.isInEditMode = isInEditMode
    self.isSelected = isSelected
    self.cardState = cardState
  }
}

public enum TodayShortsItemAction: Equatable {
  // MARK: - User Action
  case itemSelected // 체크마크 선택
  case itemTapped // 뉴스 카드 선택
  
  // MARK: - Inner Business Action
  case _fetchMoreItems(Int)
  case _shortsItemSelectionChanged
  
  // MARK: - Inner SetState Action
  
  // MARK: - Child Action
  case cardAction(TodayShortsCardAction)
}

struct TodayShortsItemEnvironment {
  public init() {}
}

let todayShortsItemReducer = Reducer.combine([
  todayShortsCardReducer
    .pullback(
      state: \TodayShortsItemState.cardState,
      action: /TodayShortsItemAction.cardAction,
      environment: { _ in
        TodayShortsCardEnvironment()
      }
    ),
  Reducer<TodayShortsItemState, TodayShortsItemAction, TodayShortsItemEnvironment> { state, action, env in
    switch action {
    case ._shortsItemSelectionChanged:
      state.isSelected.toggle()
      return .none
      
    default: return .none
    }
  }
])

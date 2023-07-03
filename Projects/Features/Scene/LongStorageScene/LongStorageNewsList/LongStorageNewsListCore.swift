//
//  LongStorageNewsListCore.swift
//  Scene
//
//  Created by GREEN on 2023/04/28.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Combine
import Common
import ComposableArchitecture
import Foundation


public struct LongStorageNewsListState: Equatable {
  var isInEditMode: Bool
  var month: String
  var shortsNewsItemsCount: Int // 저장한 숏스 수
  var shortsCompleteCount: Int // 완료한 숏스 수
  var shortsNewsItems: IdentifiedArrayOf<LongShortsItemState> = []
  var isLatestMode: Bool = true
  
  public init(
    isInEditMode: Bool,
    shortslistCount: Int,
    shortsClearCount: Int
  ) {
    self.isInEditMode = isInEditMode
    self.month = Date().yearMonthToString()
    self.shortsNewsItemsCount = shortslistCount
    self.shortsCompleteCount = shortsClearCount
  }
}

public enum LongStorageNewsListAction: Equatable {
  // MARK: - User Action
  case backButtonTapped
  case editButtonTapped
  case deleteButtonTapped
  case datePickerTapped
  case previousMonthButtonTapped
  case nextMonthButtonTapped
  case sortByTimeButtonTapped
  case sortByTypeButtonTapped
  
  // MARK: - Inner Business Action
  case _onAppear
  
  // MARK: - Inner SetState Action
  case _setEditMode
  case _setLongShortsItemEditMode
  case _setLongShortsItemList
  case _setLongShortsItemCount
  
  // MARK: - Child Action
  case shortsNewsItem(id: LongShortsItemState.ID, action: LongShortsItemAction)
}

public struct LongStorageNewsListEnvironment {
  public init() {}
}

public let longStorageNewsListReducer = Reducer<
  LongStorageNewsListState,
  LongStorageNewsListAction,
  LongStorageNewsListEnvironment
>.combine([
  longShortsItemReducer
    .forEach(
      state: \LongStorageNewsListState.shortsNewsItems,
      action: /LongStorageNewsListAction.shortsNewsItem(id:action:),
      environment: { _ in
        LongShortsItemEnvironment()
      }
    ),
  Reducer { state, action, env in
    switch action {
    case .editButtonTapped:
      return Effect.concatenate([
        Effect(value: ._setEditMode),
        Effect(value: ._setLongShortsItemEditMode)
      ])
      
    case .deleteButtonTapped:
      return Effect.concatenate([
        Effect(value: ._setEditMode),
        Effect(value: ._setLongShortsItemList),
        Effect(value: ._setLongShortsItemEditMode)
      ])
      
    case .sortByTimeButtonTapped:
      state.isLatestMode.toggle()
      return .none
      
    case .sortByTypeButtonTapped:
      // TODO: 타입에 따른 정렬 구현 필요
      return .none
      
    case ._onAppear:
      state.shortsNewsItems = LongStorageStub.items
      return .none
      
    case ._setEditMode:
      state.isInEditMode.toggle()
      return .none
      
    case ._setLongShortsItemEditMode:
      for index in 0..<state.shortsNewsItems.count {
        state.shortsNewsItems[index].isInEditMode = state.isInEditMode
        state.shortsNewsItems[index].cardState.isCardSelectable = !state.isInEditMode
      }
      return .none
      
    case ._setLongShortsItemList:
      state.shortsNewsItems.removeAll(where: \.isSelected)
      return Effect(value: ._setLongShortsItemCount)
      
    case ._setLongShortsItemCount:
      state.shortsNewsItemsCount = state.shortsNewsItems.count
      return .none
      
    default: return .none
    }
  }
])

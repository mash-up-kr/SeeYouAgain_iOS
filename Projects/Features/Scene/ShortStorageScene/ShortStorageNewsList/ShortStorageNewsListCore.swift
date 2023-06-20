//
//  ShortStorageNewsListCore.swift
//  Scene
//
//  Created by GREEN on 2023/04/28.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Combine
import ComposableArchitecture
import Foundation

public struct ShortsNews: Equatable, Identifiable {
  public let id: Int
  public let category: String
  public let keywords: String
  
  public init(id: Int, category: String, keywords: String) {
    self.id = id
    self.category = category
    self.keywords = keywords
  }
}

public struct ShortStorageNewsListState: Equatable {
  public var isInEditMode: Bool
  public var shortslistCount: Int // 저장한 숏스 수
  public var shortsClearCount: Int // 완료한 숏스 수 (리스트에 표시되는 숏스 = 저장 숏스 - 완료 숏스)
  public var shortsNewsItems: IdentifiedArrayOf<TodayShortsItemState> = []
  public var itemState: TodayShortsItemState
  
  public init(
    isInEditMode: Bool,
    shortslistCount: Int,
    shortsClearCount: Int,
    itemState: TodayShortsItemState
  ) {
    self.isInEditMode = isInEditMode
    self.shortslistCount = shortslistCount
    self.shortsClearCount = shortsClearCount
    self.itemState = itemState
  }
}

public enum ShortStorageNewsListAction: Equatable {
  // MARK: - User Action
  case backButtonTapped
  case editButtonTapped
  
  // MARK: - Inner Business Action
  case viewDidLoad
  
  // MARK: - Inner SetState Action
  case _setTodayShortsItemState(TodayShortsItemState)
  
  // MARK: - Child Action
  case shortsNewsItem(id: TodayShortsItemState.ID, action: TodayShortsItemAction)
}

public struct ShortStorageNewsListEnvironment {
  public init() {}
}

public let shortStorageNewsListReducer = Reducer.combine([
  Reducer<
  ShortStorageNewsListState,
  ShortStorageNewsListAction,
  ShortStorageNewsListEnvironment
  > { state, action, env in
    switch action {
    case .editButtonTapped:
      state.isInEditMode.toggle()
      
      if state.isInEditMode {
        state.itemState.isInEditMode = true
      }
      return .none
      
    case .viewDidLoad:
      return .none
      
    case let ._setTodayShortsItemState(itemState):
      return .none
      
    case let .shortsNewsItem(id: tappedId, action: .itemTapped):
      return .none
      
    case let .shortsNewsItem(id: tappedId, action: .itemSelected):
      return .none
      
    default: return .none
    }
  }
])

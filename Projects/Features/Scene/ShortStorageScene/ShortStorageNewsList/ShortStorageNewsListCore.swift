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
  
  public init(
    isInEditMode: Bool,
    shortslistCount: Int,
    shortsClearCount: Int
  ) {
    self.isInEditMode = isInEditMode
    self.shortslistCount = shortslistCount
    self.shortsClearCount = shortsClearCount
  }
}

public enum ShortStorageNewsListAction: Equatable {
  // MARK: - User Action
  case backButtonTapped
  case editButtonTapped
  case deleteButtonTapped
  
  // MARK: - Inner Business Action
  case _onAppear
  case _viewDidLoad
  
  // MARK: - Inner SetState Action
  case _setTodayShortsItemEditMode
  case _setTodayShortsItemList
  case _setTodayShortsItemCount
  
  // MARK: - Child Action
  case shortsNewsItem(id: TodayShortsItemState.ID, action: TodayShortsItemAction)
}

public struct ShortStorageNewsListEnvironment {
  public init() {}
}

public let shortStorageNewsListReducer = Reducer<
  ShortStorageNewsListState,
  ShortStorageNewsListAction,
  ShortStorageNewsListEnvironment
>.combine(
  todayShortsItemReducer
    .forEach(
      state: \ShortStorageNewsListState.shortsNewsItems,
      action: /ShortStorageNewsListAction.shortsNewsItem(id:action:),
      environment: { _ in
        TodayShortsItemEnvironment()
      }
    ),
  Reducer { state, action, env in
    switch action {
    case .editButtonTapped:
      state.isInEditMode.toggle()
      return Effect(value: ._setTodayShortsItemEditMode)
      
    case .deleteButtonTapped:
      state.isInEditMode.toggle()
      return Effect.concatenate([
        Effect(value: ._setTodayShortsItemList),
        Effect(value: ._setTodayShortsItemEditMode)
      ])
      
    case ._onAppear:
      // TODO: API 연결 시, 실데이터로 반영 필요
      state.shortsNewsItems = [
        TodayShortsItemState(
          id: 0,
          isInEditMode: state.isInEditMode,
          isSelected: false,
          cardState: TodayShortsCardState(
            shortsNews: ShortsNews(
              id: 0,
              category: "#세계",
              keywords: "#자위대 호위함 #사카이 료 (Sakai Ryo) #이스턴 엔데버23 #부산항"
            ),
            isCardSelectable: !state.isInEditMode,
            isSelected: false
          )
        ),
        TodayShortsItemState(
          id: 1,
          isInEditMode: state.isInEditMode,
          isSelected: false,
          cardState: TodayShortsCardState(
            shortsNews: ShortsNews(
              id: 0,
              category: "#세계",
              keywords: "#뿡뿡 호위함 #사카이 료 (Sakai Ryo) #이스턴 엔데버23 #부산항"
            ),
            isCardSelectable: !state.isInEditMode,
            isSelected: false
          )
        ),
        TodayShortsItemState(
          id: 2,
          isInEditMode: state.isInEditMode,
          isSelected: false,
          cardState: TodayShortsCardState(
            shortsNews: ShortsNews(
              id: 0,
              category: "#세계",
              keywords: "#뽕뽕 호위함 #사카이 료 (Sakai Ryo) #이스턴 엔데버23 #부산항"
            ),
            isCardSelectable: !state.isInEditMode,
            isSelected: false
          )
        ),
        TodayShortsItemState(
          id: 3,
          isInEditMode: state.isInEditMode,
          isSelected: false,
          cardState: TodayShortsCardState(
            shortsNews: ShortsNews(
              id: 0,
              category: "#세계",
              keywords: "#빵빵 호위함 #사카이 료 (Sakai Ryo) #이스턴 엔데버23 #부산항"
            ),
            isCardSelectable: !state.isInEditMode,
            isSelected: false
          )
        ),
        TodayShortsItemState(
          id: 4,
          isInEditMode: state.isInEditMode,
          isSelected: false,
          cardState: TodayShortsCardState(
            shortsNews: ShortsNews(
              id: 0,
              category: "#세계",
              keywords: "#쿵쿵 호위함 #사카이 료 (Sakai Ryo) #이스턴 엔데버23 #부산항"
            ),
            isCardSelectable: !state.isInEditMode,
            isSelected: false
          )
        ),
        TodayShortsItemState(
          id: 5,
          isInEditMode: state.isInEditMode,
          isSelected: false,
          cardState: TodayShortsCardState(
            shortsNews: ShortsNews(
              id: 0,
              category: "#세계",
              keywords: "#쿙쿙 호위함 #사카이 료 (Sakai Ryo) #이스턴 엔데버23 #부산항"
            ),
            isCardSelectable: !state.isInEditMode,
            isSelected: false
          )
        )
      ]
      return .none
      
    case ._viewDidLoad:
      return .none
      
    case ._setTodayShortsItemEditMode:
      for index in 0..<state.shortsNewsItems.count {
        state.shortsNewsItems[index].isInEditMode = state.isInEditMode
        state.shortsNewsItems[index].cardState.isCardSelectable = !state.isInEditMode
      }
      return .none
      
    case ._setTodayShortsItemList:
      state.shortsNewsItems.removeAll(where: \.isSelected)
      return Effect(value: ._setTodayShortsItemCount)
      
    case ._setTodayShortsItemCount:
      state.shortslistCount = state.shortsNewsItems.count
      return .none
      
    case let .shortsNewsItem(id: tappedId, action: .itemTapped):
      return .none
      
    case let .shortsNewsItem(id: tappedId, action: .itemSelected):
      return .none
      
    default: return .none
    }
  }
)

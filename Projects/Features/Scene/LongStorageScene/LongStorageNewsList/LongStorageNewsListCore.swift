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
import Models
import Services

public struct LongStorageNewsListState: Equatable {
  var isInEditMode: Bool
  var month: String
  var shortsNewsItemsCount: Int // 저장한 숏스 수
  var shortsNewsItems: IdentifiedArrayOf<LongShortsItemState> = []
  var isLatestMode: Bool = true
  var cursorDate: Date = .now
  var currentDate = Date()
  var pagingSize: Int = 20
  
  public init(
    isInEditMode: Bool,
    shortslistCount: Int
  ) {
    self.isInEditMode = isInEditMode
    self.month = Date().yearMonthToString()
    self.shortsNewsItemsCount = shortslistCount
  }
}

public enum LongStorageNewsListAction {
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
  case _viewWillAppear
  case _fetchSavedNews(FetchType)
  case _handleFetchSavedNewsResponse(SavedNewsList, FetchType)
  case _deleteSavedNews([Int])
  case _handleDeleteSavedNewsResponse(Result<VoidResponse?, Error>)
  
  // MARK: - Inner SetState Action
  case _setEditMode
  case _setLongShortsItemEditMode
  case _setLongShortsItem([News])
  case _setLongShortsItemList
  case _setLongShortsItemCount
  case _setSelectedItemIds
  
  // MARK: - Child Action
  case shortsNewsItem(id: LongShortsItemState.ID, action: LongShortsItemAction)
}

public struct LongStorageNewsListEnvironment {
  let mainQueue: AnySchedulerOf<DispatchQueue>
  let myPageService: MyPageService

  public init(
    mainQueue: AnySchedulerOf<DispatchQueue>,
    myPageService: MyPageService
  ) {
    self.mainQueue = mainQueue
    self.myPageService = myPageService
  }
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
      return Effect(value: ._setSelectedItemIds)
      
    case .sortByTimeButtonTapped:
      state.isLatestMode.toggle()
      return .none
      
    case .sortByTypeButtonTapped:
      // TODO: 타입에 따른 정렬 구현 필요
      return .none
      
    case ._viewWillAppear:
      return Effect(value: ._fetchSavedNews(.initial))
      
    case let ._fetchSavedNews(fetchType):
      return env.myPageService.fetchSavedNews(
        state.currentDate.toFormattedTargetDate(),
        state.pagingSize,
        .ASC
      )
      .catchToEffect()
      .flatMap { result -> Effect<LongStorageNewsListAction, Never> in
        switch result {
        case let .success(savedNewsList):
          return Effect(value: ._handleFetchSavedNewsResponse(savedNewsList, fetchType))
          
        case .failure:
          return .none
        }
      }
      .eraseToEffect()
      
    case let ._handleFetchSavedNewsResponse(savedNewsList, fetchType):
      return handleSavedNewsResponse(&state, source: savedNewsList, fetchType: fetchType)
      
    case let ._deleteSavedNews(newsIds):
      return env.myPageService.deleteNews(newsIds)
        .catchToEffect(LongStorageNewsListAction._handleDeleteSavedNewsResponse)
      
    case let ._handleDeleteSavedNewsResponse(result):
      switch result {
      case .success:
        return Effect.concatenate([
          Effect(value: ._setEditMode),
          Effect(value: ._setLongShortsItemList),
          Effect(value: ._setLongShortsItemEditMode)
        ])
        
      default: return .none
      }
      
    case ._setEditMode:
      state.isInEditMode.toggle()
      return .none
      
    case ._setLongShortsItemEditMode:
      for index in 0..<state.shortsNewsItems.count {
        state.shortsNewsItems[index].isInEditMode = state.isInEditMode
        state.shortsNewsItems[index].cardState.isCardSelectable = !state.isInEditMode
      }
      return .none

    case let ._setLongShortsItem(newsList):
      state.shortsNewsItems = IdentifiedArrayOf(uniqueElements: newsList.map {
        LongShortsItemState(
          id: $0.id,
          isInEditMode: false,
          isSelected: false,
          cardState: LongShortsCardState(
            id: $0.id,
            news: $0,
            isCardSelectable: true,
            isSelected: false
          )
        )
      })
      return .none
      
    case ._setLongShortsItemList:
      state.shortsNewsItems.removeAll(where: \.isSelected)
      return Effect(value: ._setLongShortsItemCount)
      
    case ._setLongShortsItemCount:
      state.shortsNewsItemsCount = state.shortsNewsItems.count
      return .none
      
    case ._setSelectedItemIds:
      var selectedItemIds: [Int] = []
      
      for item in state.shortsNewsItems {
        if item.isSelected {
          selectedItemIds.append(item.id)
        }
      }
      
      if selectedItemIds.isEmpty {
        return .none
      }
      return Effect(value: ._deleteSavedNews(selectedItemIds))
      
    default: return .none
    }
  }
])

private func handleSavedNewsResponse(
  _ state: inout LongStorageNewsListState,
  source savedNewsList: SavedNewsList,
  fetchType: FetchType
) -> Effect<LongStorageNewsListAction, Never> {
  switch fetchType {
  case .initial:
    state.shortsNewsItemsCount = savedNewsList.savedNewsCount
    return Effect(value: ._setLongShortsItem(savedNewsList.newsList))
    
    // TODO: 페이징 기능 구현 필요
  case .continuousPaging:
    return .none

  case .newPaging:
    return .none
  }
}

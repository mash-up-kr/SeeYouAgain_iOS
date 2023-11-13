//
//  ShortStorageNewsListCore.swift
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

public struct ShortStorageNewsListState: Equatable {
  var isInEditMode: Bool
  var today: String
  var shortsNewsItemsCount: Int // 저장한 숏스 수
  var shortsNewsItems: IdentifiedArrayOf<TodayShortsItemState> = []
  var currentTimeSeconds: Int = 0 // 지금 시간이 몇초를 담고있냐! 17:27:21 => 62841
  var cursorId: Int = 0
  var isDisplayTooltip = false
  let pagingSize = 20
  var successToastMessage: String?
  var failureToastMessage: String?
  var selectedItemCounts: Int = 0
  var isLoading: Bool
  var fetchAll = false
  
  public init(
    isInEditMode: Bool,
    shortsNewsItemsCount: Int,
    isLoading: Bool = false
  ) {
    self.isInEditMode = isInEditMode
    self.shortsNewsItemsCount = shortsNewsItemsCount
    self.today = Date().fullDateToString()
    self.isLoading = isLoading
  }
}

public enum ShortStorageNewsListAction {
  // MARK: - User Action
  case backButtonTapped
  case editButtonTapped
  case deleteButtonTapped
  case tooltipButtonTapped
  
  // MARK: - Inner Business Action
  case _onAppear
  case _onDisappear
  case _fetchTodayShorts(FetchType)
  case _handleTodayShortsResponse(KeywordNews, FetchType)
  case _deleteTodayShorts([Int])
  case _handleDeleteTodayShortsResponse(Result<VoidResponse?, Error>)
  case _presentSuccessToast(String)
  case _presentFailureToast(String)
  case _hideSuccessToast
  case _hideFailureToast
  
  // MARK: - Inner SetState Action
  case _setTodayShortsLastItem(Bool)
  case _setTodayShortsItemInitial(KeywordNews)
  case _setTodayShortsItem(KeywordNews)
  case _setEditMode
  case _setTodayShortsItemEditMode
  case _setTodayShortsItemList
  case _setTodayShortsItemCount
  case _setSelectedItemIds
  case _toggleIsDisplayTooltip
  case _setSuccessToastMessage(String?)
  case _setFailureToastMessage(String?)
  case _setIsLoading(Bool)
  
  // MARK: - Child Action
  case shortsNewsItem(id: TodayShortsItemState.ID, action: TodayShortsItemAction)
}

public struct ShortStorageNewsListEnvironment {
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
    struct SuccessToastCancelID: Hashable {}
    struct FailureToastCancelID: Hashable {}
    
    switch action {
    case .editButtonTapped:
      return Effect.concatenate([
        Effect(value: ._setEditMode),
        Effect(value: ._setTodayShortsItemEditMode)
      ])
      
    case .deleteButtonTapped:
      return Effect(value: ._setSelectedItemIds)
      
    case .tooltipButtonTapped:
      return Effect(value: ._toggleIsDisplayTooltip)
  
    case ._onAppear:
      return state.fetchAll ? .none : Effect.concatenate([
        Effect(value: ._setIsLoading(true)),
        Effect(value: ._fetchTodayShorts(.initial))
      ])
      
    case ._onDisappear:
      return Effect.merge(
        Effect(value: ._setSuccessToastMessage(nil)),
        Effect(value: ._setFailureToastMessage(nil))
      )
      
    case let ._fetchTodayShorts(fetchType):
      return env.myPageService.fetchMemberNewsCard(
        state.cursorId,
        state.pagingSize
      )
      .catchToEffect()
      .flatMap { result -> Effect<ShortStorageNewsListAction, Never> in
        switch result {
        case let .success(todayShorts):
          return Effect(value: ._handleTodayShortsResponse(todayShorts, fetchType))
          
        case .failure:
          return .none
        }
      }
      .eraseToEffect()
      
    case let ._handleTodayShortsResponse(todayShorts, fetchType):
      return Effect.concatenate([
        Effect(value: ._setIsLoading(false)),
        handleTodayShortsResponse(&state, source: todayShorts, fetchType: fetchType)
      ])

    case let ._deleteTodayShorts(shortsIds):
      return env.myPageService.deleteTodayShorts(shortsIds)
        .catchToEffect(ShortStorageNewsListAction._handleDeleteTodayShortsResponse)

    case let ._handleDeleteTodayShortsResponse(result):
      switch result {
      case .success:
        return Effect.concatenate([
          Effect(value: ._setEditMode),
          Effect(value: ._setTodayShortsItemList),
          Effect(value: ._setTodayShortsItemEditMode),
          Effect(value: ._presentSuccessToast("\(state.selectedItemCounts)개의 숏스를 삭제했어요."))
        ])
        
      case .failure:
        return Effect(value: ._presentFailureToast("인터넷이 불안정해서 삭제되지 못했어요."))
      }
      
    case let ._presentSuccessToast(toastMessage):
      return Effect.concatenate([
        Effect(value: ._setSuccessToastMessage(toastMessage)),
        .cancel(id: SuccessToastCancelID()),
        Effect(value: ._hideSuccessToast)
          .delay(for: 2, scheduler: env.mainQueue)
          .eraseToEffect()
          .cancellable(id: SuccessToastCancelID(), cancelInFlight: true)
      ])
      
    case let ._presentFailureToast(toastMessage):
      return Effect.concatenate([
        Effect(value: ._setFailureToastMessage(toastMessage)),
        .cancel(id: FailureToastCancelID()),
        Effect(value: ._hideFailureToast)
          .delay(for: 2, scheduler: env.mainQueue)
          .eraseToEffect()
          .cancellable(id: FailureToastCancelID(), cancelInFlight: true)
      ])
      
    case ._hideSuccessToast:
      return Effect(value: ._setSuccessToastMessage(nil))
      
    case ._hideFailureToast:
      return Effect(value: ._setFailureToastMessage(nil))
      
    case let ._setTodayShortsLastItem(isLast):
      if var lastItem = state.shortsNewsItems.last {
        lastItem.isLastItem = isLast
        state.shortsNewsItems.removeLast()
        state.shortsNewsItems.append(lastItem)
      }
      return .none
      
    case let ._setTodayShortsItemInitial(todayShorts):
      state.shortsNewsItems = IdentifiedArrayOf(uniqueElements: todayShorts.memberShorts.map {
        TodayShortsItemState(
          id: $0.id,
          isInEditMode: false,
          isSelected: false,
          cardState: TodayShortsCardState(
            shortsNews: NewsCard(
              id: $0.id,
              keywords: $0.keywords.replacingOccurrences(of: " ", with: "").components(separatedBy: ","),
              category: $0.category),
            isCardSelectable: true,
            isSelected: false
          )
        )
      })
      return Effect(value: ._setTodayShortsLastItem(true))

    case let ._setTodayShortsItem(todayShorts):
      state.shortsNewsItems.append(contentsOf:
        todayShorts.memberShorts.map {
          TodayShortsItemState(
            id: $0.id,
            isInEditMode: false,
            isSelected: false,
            cardState: TodayShortsCardState(
              shortsNews: NewsCard(
                id: $0.id,
                keywords: $0.keywords.replacingOccurrences(of: " ", with: "").components(separatedBy: ","),
                category: $0.category),
              isCardSelectable: true,
              isSelected: false
            )
          )
        }
      )
      return Effect(value: ._setTodayShortsLastItem(true))
      
    case ._setEditMode:
      state.isInEditMode.toggle()
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
      state.shortsNewsItemsCount = state.shortsNewsItems.count
      return .none
      
    case ._setSelectedItemIds:
      var selectedItemIds: [Int] = []
      
      for item in state.shortsNewsItems {
        if item.isSelected {
          selectedItemIds.append(item.id)
        }
      }
      state.selectedItemCounts = selectedItemIds.count
      
      if selectedItemIds.isEmpty {
        return Effect.concatenate([
          Effect(value: ._setEditMode),
          Effect(value: ._setTodayShortsItemEditMode)
        ])
      }
      return Effect(value: ._deleteTodayShorts(selectedItemIds))
      
    case let ._setIsLoading(isLoading):
      state.isLoading = isLoading
      return .none
      
    case ._toggleIsDisplayTooltip:
      state.isDisplayTooltip.toggle()
      return .none
      
    case let ._setSuccessToastMessage(toastMessage):
      state.successToastMessage = toastMessage
      return .none
      
    case let ._setFailureToastMessage(toastMessage):
      state.failureToastMessage = toastMessage
      return .none
      
    case let .shortsNewsItem(id: _, action: ._fetchMoreItems(cursorId)):
      state.cursorId = cursorId
      return state.fetchAll ? .none : Effect(value: ._fetchTodayShorts(.continuousPaging))
      
    case let .shortsNewsItem(id: tappedId, action: .itemTapped):
      return .none
      
    case let .shortsNewsItem(id: tappedId, action: .itemSelected):
      return .none
      
    default: return .none
    }
  }
)

private func handleTodayShortsResponse(
  _ state: inout ShortStorageNewsListState,
  source todayShorts: KeywordNews,
  fetchType: FetchType
) -> Effect<ShortStorageNewsListAction, Never> {
  switch fetchType {
  case .initial:
    state.shortsNewsItemsCount = todayShorts.numberOfNewsCard
    return Effect(value: ._setTodayShortsItemInitial(todayShorts))
    
  case .continuousPaging:
    state.shortsNewsItemsCount += todayShorts.memberShorts.count
    
    if todayShorts.memberShorts.isEmpty {
      state.fetchAll = true
      return .none
    }
    return Effect.concatenate(
      Effect(value: ._setTodayShortsLastItem(false)),
      Effect(value: ._setTodayShortsItem(todayShorts))
    )
    
  case .newPaging:
    return .none
  }
}

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
  var shortsCompleteCount: Int // 완료한 숏스 수 (리스트에 표시되는 숏스 = 저장 숏스 - 완료 숏스)
  var shortsNewsItems: IdentifiedArrayOf<TodayShortsItemState> = []
  var remainTimeString: String
  var remainTime: Int = 24 * 60 * 60
  var currentTimeSeconds: Int = 0 // 지금 시간이 몇초를 담고있냐! 17:27:21 => 62841
  var cursorId: Int = 0
  var isDisplayTooltip = false
  let pagingSize = 10
  
  public init(
    isInEditMode: Bool,
    shortsNewsItemsCount: Int,
    shortsCompleteCount: Int
  ) {
    self.isInEditMode = isInEditMode
    self.shortsNewsItemsCount = shortsNewsItemsCount
    self.shortsCompleteCount = shortsCompleteCount
    self.today = Date().fullDateToString()
    self.remainTimeString = initializeRemainTimeString()
  }
}

public enum ShortStorageNewsListAction {
  // MARK: - User Action
  case backButtonTapped
  case editButtonTapped
  case deleteButtonTapped
  case tooltipButtonTapped
  
  // MARK: - Inner Business Action
  case _viewWillAppear
  case _updateTimer
  case _decreaseRemainTime
  case _updateZeroTime
  case _fetchTodayShorts(FetchType)
  case _handleTodayShortsResponse(TodayShorts, FetchType)
  case _deleteTodayShorts([Int])
  case _handleDeleteTodayShortsResponse(Result<VoidResponse?, Error>)
  
  // MARK: - Inner SetState Action
  case _setTodayShortsItem(TodayShorts)
  case _setEditMode
  case _setTodayShortsItemEditMode
  case _setTodayShortsItemList
  case _setTodayShortsItemCount
  case _setSelectedItemIds
  case _setCurrentTimeSeconds
  case _setRemainTime(Int)
  case _setRemainTimeString(Int)
  case _toggleIsDisplayTooltip
  case _initializeShortStorageNewsList
  
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
    struct TimerId: Hashable {}
    
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
  
    case ._viewWillAppear:
      return Effect.concatenate([
        Effect(value: ._setCurrentTimeSeconds),
        Effect(value: ._fetchTodayShorts(.initial))
      ])
      
    case ._updateTimer:
      return Effect.timer(
        id: TimerId(),
        every: 1,
        on: env.mainQueue
      ).map { _ in
        ._decreaseRemainTime
      }
      
    case ._decreaseRemainTime:
      state.remainTime -= 1
      return Effect(value: ._setRemainTimeString(state.remainTime))
      
    case ._updateZeroTime:
      return Effect.concatenate([
        Effect(value: ._setCurrentTimeSeconds),
        Effect(value: ._initializeShortStorageNewsList)
      ])
      
    case let ._fetchTodayShorts(fetchType):
      return env.myPageService.getTodayShorts(
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
      return handleTodayShortsResponse(&state, source: todayShorts, fetchType: fetchType)

    case let ._deleteTodayShorts(shortsIds):
      return env.myPageService.deleteTodayShorts(shortsIds)
        .catchToEffect(ShortStorageNewsListAction._handleDeleteTodayShortsResponse)

    case let ._handleDeleteTodayShortsResponse(result):
      switch result {
      case .success:
        return Effect.concatenate([
          Effect(value: ._setEditMode),
          Effect(value: ._setTodayShortsItemList),
          Effect(value: ._setTodayShortsItemEditMode)
        ])
        
      default: return .none
      }

    case let ._setTodayShortsItem(todayShorts):
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
      return .none
      
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
      return Effect(value: ._deleteTodayShorts(selectedItemIds))
      
    case ._setCurrentTimeSeconds:
      state.currentTimeSeconds = calculateCurrentTimeSeconds()
      return Effect(value: ._setRemainTime(state.currentTimeSeconds))
      
    case let ._setRemainTime(currentTimeSeconds):
      state.remainTime = 24 * 60 * 60 - currentTimeSeconds
      return Effect(value: ._updateTimer)

    case let ._setRemainTimeString(time):
      state.remainTimeString = remainTimeToString(time: time)
      
      if time == 0 {
        return Effect(value: ._updateZeroTime)
      }
      return .none
      
    case ._toggleIsDisplayTooltip:
      state.isDisplayTooltip.toggle()
      return .none
      
    case ._initializeShortStorageNewsList:
      state.shortsNewsItems.removeAll()
      state.today = Date().fullDateToString()
      return Effect(value: ._fetchTodayShorts(.initial))
      
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
  source todayShorts: TodayShorts,
  fetchType: FetchType
) -> Effect<ShortStorageNewsListAction, Never> {
  switch fetchType {
  case .initial:
    state.shortsNewsItemsCount = todayShorts.numberOfShorts
    state.shortsCompleteCount = todayShorts.numberOfReadShorts
    return Effect(value: ._setTodayShortsItem(todayShorts))
    
    // TODO: 페이징 기능 구현 필요
  case .continuousPaging:
    return .none
    
  case .newPaging:
    return .none
  }
}

fileprivate func initializeRemainTimeString() -> String {
  let currentTimeSeconds = calculateCurrentTimeSeconds()
  let remainTimeSeconds = 24 * 60 * 60 - currentTimeSeconds
  return remainTimeToString(time: remainTimeSeconds)
}

fileprivate func calculateCurrentTimeSeconds() -> Int {
  let date = Date()
  var calendar = Calendar.current

  if let timeZone = TimeZone(identifier: "KST") {
    calendar.timeZone = timeZone
  }
  
  let hour = calendar.component(.hour, from: date)
  let minute = calendar.component(.minute, from: date)
  let second = calendar.component(.second, from: date)
  
  return hour * 60 * 60 + minute * 60 + second
}

fileprivate func remainTimeToString(time: Int) -> String {
  let hour = Int(time) / 3600
  let minute = Int(time) / 60 % 60
  let second = Int(time) % 60
  return String(format: "%02i:%02i:%02i", hour, minute, second)
}

fileprivate let dateComponentsFormatter: DateComponentsFormatter = {
  let formatter = DateComponentsFormatter()
  formatter.allowedUnits = [.hour, .minute, .second]
  formatter.zeroFormattingBehavior = .pad
  return formatter
}()

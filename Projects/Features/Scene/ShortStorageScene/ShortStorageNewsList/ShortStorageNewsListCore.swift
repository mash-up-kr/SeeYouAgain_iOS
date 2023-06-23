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
  public var today: String
  public var shortsNewsItemsCount: Int // 저장한 숏스 수
  public var shortsClearCount: Int // 완료한 숏스 수 (리스트에 표시되는 숏스 = 저장 숏스 - 완료 숏스)
  public var shortsNewsItems: IdentifiedArrayOf<TodayShortsItemState> = []
  public var remainTimeString: String
  var remainTime: Int = 24 * 60 * 60
  var currentTimeSeconds: Int = 0 // 지금 시간이 몇초를 담고있냐! 17:27:21 => 62841
  
  public init(
    isInEditMode: Bool,
    shortslistCount: Int,
    shortsClearCount: Int
  ) {
    self.isInEditMode = isInEditMode
    self.shortsNewsItemsCount = shortslistCount
    self.shortsClearCount = shortsClearCount
    self.today = Date().fullDateToString()
    self.remainTimeString = initializeRemainTimeString()
  }
}

public enum ShortStorageNewsListAction: Equatable {
  // MARK: - User Action
  case backButtonTapped
  case editButtonTapped
  case deleteButtonTapped
  
  // MARK: - Inner Business Action
  case _onAppear
  case _updateTimer
  case _decreaseRemainTime
  case _checkZeroTime
  
  // MARK: - Inner SetState Action
  case _setTodayShortsItemEditMode
  case _setTodayShortsItemList
  case _setTodayShortsItemCount
  case _setCurrentTimeSeconds
  case _setRemainTime(Int)
  case _setRemainTimeString(Int)
  case _initializeShortStorageNewsList
  
  // MARK: - Child Action
  case shortsNewsItem(id: TodayShortsItemState.ID, action: TodayShortsItemAction)
}

public struct ShortStorageNewsListEnvironment {
  let mainQueue: AnySchedulerOf<DispatchQueue>

  public init(
    mainQueue: AnySchedulerOf<DispatchQueue>
  ) {
    self.mainQueue = mainQueue
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
      return Effect(value: ._setCurrentTimeSeconds)
      
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
      return state.remainTime != 0 ?
      Effect(value: ._setRemainTimeString(state.remainTime)) : Effect(value: ._checkZeroTime)
      
    case ._checkZeroTime:
      return Effect.concatenate([
        Effect(value: ._setCurrentTimeSeconds),
        Effect(value: ._initializeShortStorageNewsList)
      ])
      
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
      
    case ._setCurrentTimeSeconds:
      state.currentTimeSeconds = calculateCurrentTimeSeconds()
      return Effect(value: ._setRemainTime(state.currentTimeSeconds))
      
    case let ._setRemainTime(currentTimeSeconds):
      state.remainTime = 24 * 60 * 60 - currentTimeSeconds
      return Effect(value: ._updateTimer)

    case let ._setRemainTimeString(time):
      state.remainTimeString = remainTimeToString(time: time)
      return .none
      
    case ._initializeShortStorageNewsList:
      // TODO: 실데이터 반영 필요
      state.shortsNewsItems.removeAll()
      state.shortsNewsItemsCount = 0
      state.shortsClearCount = 0
      state.today = Date().fullDateToString()
      return .none
      
    case let .shortsNewsItem(id: tappedId, action: .itemTapped):
      return .none
      
    case let .shortsNewsItem(id: tappedId, action: .itemSelected):
      return .none
      
    default: return .none
    }
  }
)

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

// TODO: 코드 위치 변경 필요
fileprivate let dateComponentsFormatter: DateComponentsFormatter = {
  let formatter = DateComponentsFormatter()
  formatter.allowedUnits = [.hour, .minute, .second]
  formatter.zeroFormattingBehavior = .pad
  return formatter
}()

// TODO: 코드 위치 변경 필요
extension Date {
  func fullDateToString() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy년 M월 dd일"
    dateFormatter.locale = Locale(identifier: "ko_KR")
    dateFormatter.timeZone = TimeZone(identifier: "KST")
    return dateFormatter.string(from: self)
  }
  
  func yearMonthToString() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy년 M월"
    dateFormatter.locale = Locale(identifier: "ko_KR")
    dateFormatter.timeZone = TimeZone(identifier: "KST")
    return dateFormatter.string(from: self)
  }
}

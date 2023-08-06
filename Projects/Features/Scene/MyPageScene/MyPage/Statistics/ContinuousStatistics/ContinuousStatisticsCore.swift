//
//  ContinuousStatisticsCore.swift
//  MyPage
//
//  Created by 안상희 on 2023/08/01.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import ComposableArchitecture
import Foundation
import Models
import Services

public struct ContinuousStatisticsState: Equatable {
  var dateOfShortsRead: DateOfShortsRead
  var consecutiveDaysOfThisWeek: Int = 0
  var consecutiveDaysOfLastWeek: Int = 0
  var consecutiveDaysDifference: String = ""
  var dayList: [String] = ["월", "화", "수", "목", "금", "토", "일"]
  
  public init(dateOfShortsRead: DateOfShortsRead) {
    self.dateOfShortsRead = dateOfShortsRead
  }
}

public enum ContinuousStatisticsAction {
  // MARK: - Inner Business Action
  case _onAppear
  case _calculateStates
  case _calculateConsecutiveDaysOfThisWeek
  case _calculateConsecutiveDaysOfLastWeek
  case _calculateDayList
  
  // MARK: - Inner SetState Action
  case _setConsecutiveDaysOfThisWeek(Int)
  case _setConsecutiveDaysOfLastWeek(Int)
  case _setConsecutiveDaysDifference
  case _setDayList([String])
}

public struct ContinuousStatisticsEnvironment {
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

public let continuousStatisticsReducer = Reducer<
  ContinuousStatisticsState,
  ContinuousStatisticsAction,
  ContinuousStatisticsEnvironment
> { state, action, env in
  switch action {
  case ._onAppear:
    return Effect(value: ._calculateStates)
    
  case ._calculateStates:
    return Effect.concatenate([
      Effect(value: ._calculateConsecutiveDaysOfThisWeek),
      Effect(value: ._calculateConsecutiveDaysOfLastWeek),
      Effect(value: ._calculateDayList)
    ])
    
  case ._calculateConsecutiveDaysOfThisWeek:
    let dateList = dateStringToDateList(state.dateOfShortsRead.thisWeek)
    let maxConsecutiveDays = maxConsecutiveDays(dateList)
    return Effect(value: ._setConsecutiveDaysOfThisWeek(maxConsecutiveDays))
    
  case ._calculateConsecutiveDaysOfLastWeek:
    let dateList = dateStringToDateList(state.dateOfShortsRead.lastWeek)
    let maxConsecutiveDays = maxConsecutiveDays(dateList)
    return Effect(value: ._setConsecutiveDaysOfLastWeek(maxConsecutiveDays))
    
  case ._calculateDayList:
    let thisWeek = state.dateOfShortsRead.thisWeek
    var list = [String]()
    for day in thisWeek {
      list.append(day.stringToDate().day())
    }
    return Effect(value: ._setDayList(list))
    
  case let ._setConsecutiveDaysOfThisWeek(days):
    state.consecutiveDaysOfThisWeek = days
    return .none
    
  case let ._setConsecutiveDaysOfLastWeek(days):
    state.consecutiveDaysOfLastWeek = days
    return Effect(value: ._setConsecutiveDaysDifference)
    
  case ._setConsecutiveDaysDifference:
    let difference = state.consecutiveDaysOfThisWeek - state.consecutiveDaysOfLastWeek
    let differenceString = ConsecutiveDay(rawValue: difference)?.description ?? ""
    state.consecutiveDaysDifference = differenceString
    return .none
    
  case let ._setDayList(dayList):
    for index in 0..<state.dayList.count {
      if dayList.contains(state.dayList[index]) {
        state.dayList[index] = ""
      }
    }
    return .none
  }
}

private func dateStringToDateList(_ dates: [String]) -> [Date] {
  var dateList = [Date]()
  for date in dates {
    dateList.append(date.stringToDate())
  }
  return dateList
}

private func maxConsecutiveDays(_ dates: [Date]) -> Int {
  // 날짜 오름차순 정렬
  let sortedDates = dates.sorted()
  
  // 첫 번째 날짜와 비교하기 위한 이전 날짜 변수
  var previousDate: Date?
  
  // 현재 연속된 날짜 수와 최대 연속된 날짜 수를 저장할 변수
  var currentConsecutiveDays = 0
  var maxConsecutiveDays = 0
  
  for date in sortedDates {
    // 이전 날짜가 있고, 현재 날짜와의 차이가 1일이라면 연속된 날짜로 간주하고 카운트 증가
    if let previous = previousDate, date.timeIntervalSince(previous) == 86400 {
      currentConsecutiveDays += 1
    } else {
      // 연속되지 않은 날짜라면 현재 연속된 날짜 수를 최대 연속된 날짜 수와 비교하여 갱신
      maxConsecutiveDays = max(maxConsecutiveDays, currentConsecutiveDays)
      currentConsecutiveDays = 1
    }
    previousDate = date
  }
  
  // 마지막 날짜까지 연속된 경우를 고려하여 최대 연속된 날짜 수를 다시 확인하여 반환
  return max(maxConsecutiveDays, currentConsecutiveDays)
}

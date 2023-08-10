//
//  StatisticsCore.swift
//  MyPage
//
//  Created by 안상희 on 2023/07/29.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Common
import ComposableArchitecture
import Foundation
import Models
import Services

public struct StatisticsState: Equatable {
  public static func == (lhs: StatisticsState, rhs: StatisticsState) -> Bool {
    return lhs.weeklyShortsCountList.first?.key == rhs.weeklyShortsCountList.last?.key
  }
  
  var statistics: Statistics
  var weeklyStatistics: WeeklyStatisticsState
  var categoryStatistics: CategoryStatisticsState
  var continuousStatistics: ContinuousStatisticsState
  var weeklyShortsCount: [String: Int] // 주차, 각 주차 당 읽은 숏스 수
  var weeklyShortsCountList: [(key: String, value: Int)] // 주차, 각 주차 당 읽은 숏스 수
  var currentWeek: String // 현재 월 주차
  var topReadCategory: String = "WORLD"
  
  public init(statistics: Statistics) {
    self.statistics = statistics
    self.weeklyShortsCount = statistics.weeklyShortsCount
    self.weeklyShortsCountList = sortKeysByMonthAndWeek(statistics.weeklyShortsCount)
    self.currentWeek = self.weeklyShortsCountList.last?.key ?? "-월 -주차"
    
    self.weeklyStatistics = WeeklyStatisticsState(weeklyShortsCountList: weeklyShortsCountList)
    self.categoryStatistics = CategoryStatisticsState(categoryOfInterest: statistics.categoryOfInterest)
    self.continuousStatistics = ContinuousStatisticsState(dateOfShortsRead: statistics.dateOfShortsRead)
  }
}

public enum StatisticsAction {
  // MARK: - Inner Business Action
  case _calculateStates
  
  // MARK: - Inner SetState Action
  case _setTopReadCategory
  
  // MARK: - Child Action
  case weeklyStatisticsAction(WeeklyStatisticsAction)
  case categoryStatisticsAction(CategoryStatisticsAction)
  case continuousStatisticsAction(ContinuousStatisticsAction)
}

public struct StatisticsEnvironment {
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

public let statisticsReducer = Reducer<
  StatisticsState,
  StatisticsAction,
  StatisticsEnvironment
>.combine([
  weeklyStatisticsReducer
    .pullback(
      state: \.weeklyStatistics,
      action: /StatisticsAction.weeklyStatisticsAction,
      environment: {
        WeeklyStatisticsEnvironment(mainQueue: $0.mainQueue, myPageService: $0.myPageService)
      }
    ),
  categoryStatisticsReducer
    .pullback(
      state: \.categoryStatistics,
      action: /StatisticsAction.categoryStatisticsAction,
      environment: {
        CategoryStatisticsEnvironment(mainQueue: $0.mainQueue, myPageService: $0.myPageService)
      }
    ),
  continuousStatisticsReducer
    .pullback(
      state: \.continuousStatistics,
      action: /StatisticsAction.continuousStatisticsAction,
      environment: {
        ContinuousStatisticsEnvironment(mainQueue: $0.mainQueue, myPageService: $0.myPageService)
      }
    ),
  Reducer { state, action, env in
    switch action {
    case ._calculateStates:
      return Effect.concatenate([
        Effect(value: .weeklyStatisticsAction(._calculateStates)),
        Effect(value: .categoryStatisticsAction(._calculateStates)),
        Effect(value: .continuousStatisticsAction(._calculateStates))
      ])
      
    case ._setTopReadCategory:
      state.topReadCategory = state.categoryStatistics.categoryOfInterestList[0].key
      return .none
    
    case .categoryStatisticsAction(._setTopReadCategory):
      return Effect(value: ._setTopReadCategory)

    default:
      return .none
    }
  }
])

private func sortKeysByMonthAndWeek(_ dictionary: [String: Int]) -> [(key: String, value: Int)] {
  var dictionaryList = dictionary.sorted { $0.key < $1.key }
  
  for index in 0..<dictionaryList.count {
    dictionaryList[index].key = splitYear(dictionaryList[index].key)
  }
  return dictionaryList
}

private func splitYear(_ string: String) -> String {
  guard let index: String.Index = string.firstIndex(of: " ") else { return "" }
  var week = "\(string[index...])"
  week.removeFirst()
  return week
}

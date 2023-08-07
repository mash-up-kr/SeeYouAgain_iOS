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
  var statistics: Statistics
  var weeklyStatistics: WeeklyStatisticsState
  var categoryStatistics: CategoryStatisticsState
  var continuousStatistics: ContinuousStatisticsState
  var currentWeek: String = Date().currentWeek()
  
  public init(statistics: Statistics) {
    self.statistics = statistics
    
    self.weeklyStatistics = WeeklyStatisticsState(weeklyShortsCount: statistics.weeklyShortsCount)
    self.categoryStatistics = CategoryStatisticsState(categoryOfInterest: statistics.categoryOfInterest)
    self.continuousStatistics = ContinuousStatisticsState(dateOfShortsRead: statistics.dateOfShortsRead)
  }
}

public enum StatisticsAction {
  // MARK: - Inner Business Action
  case _onAppear
  
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
    default:
      return .none
    }
  }
])

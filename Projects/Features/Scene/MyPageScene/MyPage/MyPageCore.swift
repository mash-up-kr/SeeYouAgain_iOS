//
//  MyPageCore.swift
//  MyPage
//
//  Created by 안상희 on 2023/05/22.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import ComposableArchitecture
import Foundation
import Models
import Services

public struct MyPageState: Equatable {
  var info: MyInfoState = MyInfoState(user: .stub)
  var statistics: StatisticsState = StatisticsState(statistics: .stub)
  var myAchievements: MyAchievementsState = MyAchievementsState()
  
  public init() {}
}

public enum MyPageAction {
  // MARK: - User Action
  case settingButtonTapped
  
  // MARK: - Inner Business Action
  case _onAppear
  case _fetchUserInfo
  case _fetchWeeklyStats
  
  // MARK: - Inner SetState Action
  case _setMyInfoState(User)
  case _setStatisticsState(Statistics)

  // MARK: - Child Action
  case info(MyInfoAction)
  case statisticsAction(StatisticsAction)
  case myAchievementsAction(MyAchievementsAction)
}

public struct MyPageEnvironment {
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

fileprivate enum CancelID: Hashable, CaseIterable {
  case _fetchUserInfo
}

public let myPageReducer = Reducer<
  MyPageState,
  MyPageAction,
  MyPageEnvironment
>.combine([
  myInfoReducer
    .pullback(
      state: \MyPageState.info,
      action: /MyPageAction.info,
      environment: {
        MyInfoEnvironment(myPageService: $0.myPageService)
      }
    ),
  myAchievementsReducer
    .pullback(
      state: \.myAchievements,
      action: /MyPageAction.myAchievementsAction,
      environment: {
        MyAchievementsEnvironment(mainQueue: $0.mainQueue, myPageService: $0.myPageService)
      }
    ),
  statisticsReducer
    .pullback(
      state: \.statistics,
      action: /MyPageAction.statisticsAction,
      environment: {
        StatisticsEnvironment(mainQueue: $0.mainQueue, myPageService: $0.myPageService)
      }
    ),
  Reducer { state, action, env in
    switch action {
    case ._onAppear:
      return Effect.concatenate([
        Effect(value: ._fetchUserInfo),
        Effect(value: ._fetchWeeklyStats)
      ])
      
    case ._fetchUserInfo:
      return env.myPageService.getMemberInfo()
        .catchToEffect()
        .flatMap { result -> Effect<MyPageAction, Never> in
          switch result {
          case let .success(user):
            return Effect(value: ._setMyInfoState(user))
            
          case .failure:
            return .none
          }
        }
        .eraseToEffect()
      
    case ._fetchWeeklyStats:
      return env.myPageService.fetchWeeklyStats()
        .catchToEffect()
        .flatMap { result -> Effect<MyPageAction, Never> in
          switch result {
          case let .success(statistics):
            return Effect.concatenate([
              Effect(value: ._setStatisticsState(statistics)),
              Effect(value: .statisticsAction(.weeklyStatisticsAction(._calculateStates)))
            ])

          case .failure:
            return .none
          }
        }
        .eraseToEffect()
      
    case let ._setMyInfoState(user):
      state.info = MyInfoState(user: user)
      return .none
      
    case let ._setStatisticsState(statistics):
      state.statistics = StatisticsState(statistics: statistics)
      return .none
      
    default: return .none
    }
  }
])

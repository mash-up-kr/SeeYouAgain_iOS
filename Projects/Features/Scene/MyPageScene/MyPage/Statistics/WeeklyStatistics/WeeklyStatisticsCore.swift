//
//  WeeklyStatisticsCore.swift
//  MyPage
//
//  Created by 안상희 on 2023/07/30.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import ComposableArchitecture
import Foundation
import Models
import Services

public struct WeeklyStatisticsState: Equatable {
  public static func == (lhs: WeeklyStatisticsState, rhs: WeeklyStatisticsState) -> Bool {
    return lhs.weeklyShortsCountList.first?.key == rhs.weeklyShortsCountList.last?.key
  }
  
  var weeklyShortsCountList: [(key: String, value: Int)] // 주차, 각 주차 당 읽은 숏스 수
  var weeklyShortsCountDifference: Int = 0 // 지난 주와 이번 주 숏스 읽은 수 비교 값
  var weeklyShortsCountDifferenceString: String = ""
  var weeklyShortsPercentageList: [Double] = Array(repeating: 0.0, count: 4) // 4주간 읽은 숏스 비율을 담은 리스트
  var shortsCountOfThisWeek = 0 // 이번주 읽은 숏스 카운트
  var totalOfFourWeeksShortsCount = 0 // 4주 간의 숏스 데이터 더한 값
  var shortsMaxPercentage = 0.0 // 4주 중 가장 많이 읽은 숏스 수
  
  init(weeklyShortsCountList: [(key: String, value: Int)]) {
    self.weeklyShortsCountList = weeklyShortsCountList
  }
}

public enum WeeklyStatisticsAction {
  // MARK: - Inner Business Action
  case _onAppear
  case _calculateStates
  case _calculateTotalOfFourWeeksShortsCount // 4주 간의 숏스 데이터 더하는 로직
  case _calculateShortsMaxPercentage
  
  // MARK: - Inner SetState Action
  case _setWeeklyShortsCountDifference // 지난 주와 이번 주 숏스 읽은 수 비교 값 계산
  case _setWeeklyShortsCountDifferenceString
  case _setWeeklyShortsPercentageList // 4주 간의 숏스 데이터를 퍼센테이지 비율로 저장
  case _setShortsCountOfThisWeek // 이번주 읽은 숏스 카운트
  case _setTotalOfFourWeeksShortsCount(Int) // 4주 간의 숏스 데이터 계산
  case _setShortsMaxPercentage(Double) // maxPercentage 기준으로 그래프뷰 높이 계산
}

public struct WeeklyStatisticsEnvironment {
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

public let weeklyStatisticsReducer = Reducer<
  WeeklyStatisticsState,
  WeeklyStatisticsAction,
  WeeklyStatisticsEnvironment
> { state, action, env in
  switch action {
  case ._onAppear:
    return .none
    
  case ._calculateStates:
    return Effect.concatenate([
      Effect(value: ._setWeeklyShortsCountDifference),
      Effect(value: ._setShortsCountOfThisWeek),
      Effect(value: ._calculateTotalOfFourWeeksShortsCount)
    ])
    
  case ._calculateTotalOfFourWeeksShortsCount:
    var total = 0
    for element in state.weeklyShortsCountList {
      total += element.value
    }
    return Effect(value: ._setTotalOfFourWeeksShortsCount(total))
    
  case ._calculateShortsMaxPercentage:
    let maxValue = state.weeklyShortsPercentageList.max() ?? 0.0
    return Effect(value: ._setShortsMaxPercentage(maxValue))
    
  case ._setWeeklyShortsCountDifference:
    state.weeklyShortsCountDifference = state.weeklyShortsCountList[3].value - state.weeklyShortsCountList[2].value
    return Effect(value: ._setWeeklyShortsCountDifferenceString)
    
  case ._setWeeklyShortsCountDifferenceString:
    if state.weeklyShortsCountDifference > 0 { // 이번주 > 저번주
      state.weeklyShortsCountDifferenceString = "\(state.weeklyShortsCountDifference)개 더"
    } else if state.weeklyShortsCountDifference == 0 { // 이번주랑 저번주랑 동일
      state.weeklyShortsCountDifferenceString = ""
    } else { // 이번주 < 저번주
      state.weeklyShortsCountDifferenceString = "\(-state.weeklyShortsCountDifference)개 덜"
    }
    return .none
    
  case ._setShortsCountOfThisWeek:
    state.shortsCountOfThisWeek = state.weeklyShortsCountList.last?.value ?? 0
    return .none
    
  case let ._setTotalOfFourWeeksShortsCount(total):
    state.totalOfFourWeeksShortsCount = total
    return total == 0 ? .none : Effect(value: ._setWeeklyShortsPercentageList)
    
  case ._setWeeklyShortsPercentageList:
    var percentageList: [Double] = []
    
    for element in state.weeklyShortsCountList {
      let percentage = Double(element.value) / Double(state.totalOfFourWeeksShortsCount)
      percentageList.append(percentage)
    }
    state.weeklyShortsPercentageList = percentageList
    return Effect(value: ._calculateShortsMaxPercentage)
    
  case let ._setShortsMaxPercentage(percentage):
    state.shortsMaxPercentage = percentage
    return .none
  }
}

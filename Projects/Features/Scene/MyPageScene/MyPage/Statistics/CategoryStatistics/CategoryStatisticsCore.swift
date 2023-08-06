//
//  CategoryStatisticsCore.swift
//  MyPage
//
//  Created by 안상희 on 2023/07/30.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Common
import ComposableArchitecture
import Foundation
import Models
import Services

public struct CategoryStatisticsState: Equatable {
  public static func == (lhs: CategoryStatisticsState, rhs: CategoryStatisticsState) -> Bool {
    return lhs.categoryOfInterestList.first?.key == rhs.categoryOfInterestList.last?.key
  }
  
  var categoryOfInterest: [String: Int]? // 이번 주 숏스 전체 읽은 수, 카테고리별 숏스 수 TOP 3
  var categoryOfInterestList: [(key: String, value: Int)] // 이번 주 숏스 전체 읽은 수, 카테고리별 숏스 수 TOP 3을 배열로 담음
  var categoryOfInterestPercentageList: [(key: String, value: Double)] = []
  var shortsCountOfThisWeek = 0 // 이번주 읽은 숏스 카운트
  var topReadCount = 0 // 가장 많이 읽은 카테고리의 숏스 수
  var topReadCategory = "경제" // 가장 많이 읽은 카테고리
  
  public init(categoryOfInterest: [String: Int]?) {
    self.categoryOfInterest = categoryOfInterest
    self.categoryOfInterestList = sortKeysByValue(
      categoryOfInterest ?? ["ECONOMIC" : 0, "WORLD" : 0, "CULTURE" : 0]
    )
  }
}

public enum CategoryStatisticsAction {
  // MARK: - Inner Business Action
  case _onAppear
  case _calculateStates
  
  // MARK: - Inner SetState Action
  case _setShortsCountOfThisWeek
  case _setTopReadCount
  case _setTopReadCategory
  case _setCategoryOfInterestPercentageList
}

public struct CategoryStatisticsEnvironment {
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

public let categoryStatisticsReducer = Reducer<
  CategoryStatisticsState,
  CategoryStatisticsAction,
  CategoryStatisticsEnvironment
> { state, action, env in
  switch action {
  case ._onAppear:
    return .none
    
  case ._calculateStates:
    guard let categoryOfInterest = state.categoryOfInterest else {
      return .none
    }
    return Effect.concatenate([
      Effect(value: ._setShortsCountOfThisWeek),
      Effect(value: ._setTopReadCount),
      Effect(value: ._setTopReadCategory),
      Effect(value: ._setCategoryOfInterestPercentageList)
    ])
    
  case ._setShortsCountOfThisWeek:
    state.shortsCountOfThisWeek = state.categoryOfInterestList.first?.value ?? 0
    return .none
    
  case ._setTopReadCount:
    state.topReadCount = state.categoryOfInterestList[1].value
    return .none
    
  case ._setTopReadCategory:
    state.topReadCategory = CategoryType(uppercasedName: state.categoryOfInterestList[1].key)?.rawValue ?? "카테고리 없음"
    return .none
    
  case ._setCategoryOfInterestPercentageList:
    var percentageList: [(key: String, value: Double)] = []
    var sum = 0
    
    for index in 0..<state.categoryOfInterestList.count {
      let percentage = Double(state.categoryOfInterestList[index].value) / Double(state.shortsCountOfThisWeek)
      percentageList.append((key: state.categoryOfInterestList[index].key, value: percentage))
      
      if index != 0 {
        sum += state.categoryOfInterestList[index].value
      }
    }
    percentageList.append(
      (
        key: "기타",
        value: Double(state.shortsCountOfThisWeek - sum) / Double(state.shortsCountOfThisWeek)
      )
    )
    state.categoryOfInterestPercentageList = percentageList
    return .none
  }
}

private func sortKeysByValue(_ dictionary: [String: Int]) -> [(key: String, value: Int)] {
  return dictionary.sorted { $0.value > $1.value }
}

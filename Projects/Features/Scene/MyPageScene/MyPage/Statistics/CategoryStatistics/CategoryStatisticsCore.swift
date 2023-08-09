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
  
  var categoryOfInterest: [String: Int] // 이번 주 숏스 전체 읽은 수, 카테고리별 숏스 수 TOP 3
  var categoryOfInterestList: [(key: String, value: Int)] // 이번 주 숏스 전체 읽은 수, 카테고리별 숏스 수 TOP 3을 배열로 담음
  var categoryOfInterestPercentageList: [(key: String, value: Double)] = []
  var shortsCountOfThisWeek = 0 // 이번주 읽은 숏스 카운트
  var topReadCount = 0 // 가장 많이 읽은 카테고리의 숏스 수
  var topReadCategory = "경제" // 가장 많이 읽은 카테고리
  var graphHeight: CGFloat = 135
  
  public init(categoryOfInterest: [String: Int]) {
    self.categoryOfInterest = categoryOfInterest
    self.categoryOfInterestList = sortKeysByValue(categoryOfInterest)
  }
}

public enum CategoryStatisticsAction {
  // MARK: - Inner Business Action
  case _onAppear
  case _calculateStates
  
  // MARK: - Inner SetState Action
  case _setEmptyCategoryOfInterestList // 주간 숏스 데이터 없을 때 보여줘야하는 초기 배열
  case _setCategoryOfInterestListAndShortsCount
  case _setShortsCountOfThisWeek
  case _setTopReadCount
  case _setTopReadCategory
  case _setCategoryOfInterestPercentageList
  case _setGraphHeight
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
    // total이 0일 때 == 읽은 데이터 없을 때
    if state.categoryOfInterest.count == 1 {
      return Effect.concatenate([
        Effect(value: ._setShortsCountOfThisWeek),
        Effect(value: ._setEmptyCategoryOfInterestList)
      ])
    }
    
    return Effect.concatenate([
      Effect(value: ._setCategoryOfInterestListAndShortsCount),
      Effect(value: ._setTopReadCount),
      Effect(value: ._setTopReadCategory),
      Effect(value: ._setCategoryOfInterestPercentageList),
      Effect(value: ._setGraphHeight)
    ])
    
  case ._setEmptyCategoryOfInterestList:
    state.categoryOfInterestList = [
      (key: "ECONOMIC", value: 0),
      (key: "WORLD", value: 0),
      (key: "CULTURE", value: 0)
    ]
    return .none
    
  case ._setCategoryOfInterestListAndShortsCount:
    // total의 key, value 제거 (total은 무조건 첫번쨰 인덱스에 있음!)
    state.categoryOfInterestList = sortKeysByValue(state.categoryOfInterest)
    state.shortsCountOfThisWeek = state.categoryOfInterestList.first?.value ?? 0
    state.categoryOfInterestList.removeFirst()
    return .none
    
  case ._setShortsCountOfThisWeek:
    state.shortsCountOfThisWeek = state.categoryOfInterestList.first?.value ?? 0
    return .none
    
  case ._setTopReadCount:
    state.topReadCount = state.categoryOfInterestList.first?.value ?? 0
    return .none
    
  case ._setTopReadCategory:
    state.topReadCategory = CategoryType(uppercasedName: state.categoryOfInterestList[0].key)?.rawValue ?? "카테고리 없음"
    return .none
    
  case ._setCategoryOfInterestPercentageList:
    var percentageList: [(key: String, value: Double)] = []
    var sum = 0
    
    for index in 0..<state.categoryOfInterestList.count {
      let percentage = Double(state.categoryOfInterestList[index].value) / Double(state.shortsCountOfThisWeek)
      percentageList.append((key: state.categoryOfInterestList[index].key, value: percentage))
      sum += state.categoryOfInterestList[index].value
    }
    
    if sum != state.shortsCountOfThisWeek {
      percentageList.append(
        (
          key: "기타",
          value: Double(state.shortsCountOfThisWeek - sum) / Double(state.shortsCountOfThisWeek)
        )
      )
    }
    state.categoryOfInterestPercentageList = percentageList
    return .none
    
  case ._setGraphHeight:
    var height: CGFloat = 52 // 20 (그래프너비) + 32 (간격)
    
    // 텍스트 표시 높이
    if state.categoryOfInterestList.count == 3 {
      height += 83
    } else if state.categoryOfInterestList.count == 2 {
      height += 50
    } else if state.categoryOfInterestList.count == 1 {
      height += 17
    }
    state.graphHeight = height
    return .none
  }
}

private func sortKeysByValue(_ dictionary: [String: Int]) -> [(key: String, value: Int)] {
  var dictionaryList = dictionary.sorted { $0.value > $1.value }
  return moveTotalKeyToFirstIndex(dictionaryList)
}

private func moveTotalKeyToFirstIndex(_ dictionaryList: [(key: String, value: Int)]) -> [(key: String, value: Int)] {
  var list = dictionaryList
  if let index = list.firstIndex(where: { $0.key == "total" }) {
    let element = list.remove(at: index)
    list.insert(element, at: 0)
  }
  return list
}

//
//  DateFilterBottomSheetCore.swift
//  LongStorageNewsList
//
//  Created by 안상희 on 2023/07/06.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Common
import ComposableArchitecture
import Foundation

public struct DateType: Equatable {
  var year: Int
  var month: Int
  
  public init(year: Int, month: Int) {
    self.year = year
    self.month = month
  }
}

struct DateFilterBottomSheetState: Equatable {
  public var year: Int = Date().yearToInt()
  public var month: Int = Date().monthToInt() - 1 // 피커에서 배열 인덱스로 사용해서 1을 빼줌
  public var isPresented: Bool
  
  public var years: [Int] = [2023]
  public var months = [Int](1...Date().monthToInt())
  
  init(isPresented: Bool = false) {
    self.isPresented = isPresented
  }
}

public enum DateFilterBottomSheetAction {
  // MARK: User Action
  case confirmBottomButtonTapped
  case selectDate(Int, Int)
  
  // MARK: Inner Business Action
  case _filter(Int, Int) // 상위 코어 전달 액션
  
  // MARK: Inner Set State Action
  case _setSelectedYear(Int)
  case _setSelectedMonth(Int)
  case _setIsPresented(Bool)
}

struct DateFilterBottomSheetEnvironment {
  init() {}
}

let dateFilterBottomSheetReducer = Reducer<
  DateFilterBottomSheetState,
  DateFilterBottomSheetAction,
  DateFilterBottomSheetEnvironment
> { state, action, env in
  switch action {
  case .confirmBottomButtonTapped:
    return Effect(value: ._filter(state.year, state.month + 1)) // 1을 빼줬으므로 다시 1 더해줘야 실제 월로 전달.

  case ._filter:
    return .none
    
  case let ._setSelectedYear(year):
    state.year = year
    return .none
    
  case let ._setSelectedMonth(month):
    state.month = month // 4월이면 3으로, 1월이면 0으로 나옴.
    return .none
    
  case let ._setIsPresented(isPresented):
    state.isPresented = isPresented
    return .none
    
  default: return .none
  }
}

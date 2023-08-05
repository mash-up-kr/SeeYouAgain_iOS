//
//  CategoryStatisticsCore.swift
//  MyPage
//
//  Created by 안상희 on 2023/07/30.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import ComposableArchitecture
import Foundation
import Models
import Services

public struct CategoryStatisticsState: Equatable {
  var shortsCountOfThisWeek = 36 // 이번주 읽은 숏스 카운트
  var topReadCategory = "경제" // 가장 많이 읽은 카테고리
  var topReadCount = 24 // 가장 많이 읽은 카테고리의 숏스 수
  
  init() {}
}

public enum CategoryStatisticsAction {
  // MARK: - Inner Business Action
  case _onAppear
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
  }
}

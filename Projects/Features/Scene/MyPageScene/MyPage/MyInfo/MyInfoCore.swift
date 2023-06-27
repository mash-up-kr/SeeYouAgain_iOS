//
//  MyInfoCore.swift
//  MyPage
//
//  Created by 안상희 on 2023/06/15.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import ComposableArchitecture
import Models
import Services

public struct MyInfoState: Equatable {
  var user: User
  var shorts: MyShortsState
  
  public init(
    user: User
  ) {
    self.user = user
    self.shorts = MyShortsState(
      shorts: MyShorts(
        totalShortsCount: user.totalShortsThisMonth,
        todayShortsCount: user.todayShorts,
        savedShortsCount: user.savedShorts
      )
    )
  }
}

public enum MyInfoAction {
  case shortsAction(MyShortsAction)
}

public struct MyInfoEnvironment {
  let myPageService: MyPageService
  
  public init(myPageService: MyPageService) {
    self.myPageService = myPageService
  }
}

public let myInfoReducer = Reducer<
  MyInfoState,
  MyInfoAction,
  MyInfoEnvironment
>.combine([
  myShortsReducer
    .pullback(
      state: \MyInfoState.shorts,
      action: /MyInfoAction.shortsAction,
      environment: { _ in
        MyShortsEnvironment()
      }
    ),
  Reducer { state, action, env in
    switch action {
    default: return .none
    }
  }
])

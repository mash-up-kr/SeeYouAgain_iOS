//
//  MyInfoCore.swift
//  MyPage
//
//  Created by 안상희 on 2023/06/15.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import ComposableArchitecture

public struct MyInfo: Equatable {
  var nickname: String
  var day: Int
  
  public init(
    nickname: String,
    day: Int
  ) {
    self.nickname = nickname
    self.day = day
  }
}

public struct MyInfoState: Equatable {
  public var info: MyInfo
  public var shorts: MyShortsState
  
  public init(
    info: MyInfo,
    shorts: MyShortsState
  ) {
    self.info = info
    self.shorts = shorts
  }
}

public enum MyInfoAction {
  case shortsAction(MyShortsAction)
}

public struct MyInfoEnvironment {
  public init() {}
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

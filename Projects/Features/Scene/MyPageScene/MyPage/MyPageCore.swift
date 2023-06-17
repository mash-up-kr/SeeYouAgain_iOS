//
//  MyPageCore.swift
//  MyPage
//
//  Created by 안상희 on 2023/05/22.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import ComposableArchitecture

public struct MyPageState: Equatable {
  var info: MyInfoState
  
  public init(
    info: MyInfoState
  ) {
    self.info = info
  }
}

public enum MyPageAction {
  case info(MyInfoAction)
  case settingButtonTapped
}

public struct MyPageEnvironment {
  public init() {}
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
      environment: { _ in
        MyInfoEnvironment()
      }
    ),
  Reducer { state, action, env in
    switch action {
    default: return .none
    }
  }
])

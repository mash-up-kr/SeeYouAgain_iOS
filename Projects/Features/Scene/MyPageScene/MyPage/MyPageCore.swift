//
//  MyPageCore.swift
//  MyPage
//
//  Created by 안상희 on 2023/05/22.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import ComposableArchitecture

public struct MyPageState: Equatable {
  public init() {}
}

public enum MyPageAction {}

public struct MyPageEnvironment {
  public init() {}
}

public let myPageReducer = Reducer.combine([
  Reducer<MyPageState, MyPageAction, MyPageEnvironment> { state, action, env in
    switch action {
    default: return .none
    }
  }
])

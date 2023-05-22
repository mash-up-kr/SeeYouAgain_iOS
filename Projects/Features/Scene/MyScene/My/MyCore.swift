//
//  MyCore.swift
//  My
//
//  Created by 안상희 on 2023/05/22.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import ComposableArchitecture

public struct MyState: Equatable {
  public init() {}
}

public enum MyAction {}

public struct MyEnvironment {
  public init() {}
}

public let myReducer = Reducer.combine([
  Reducer<MyState, MyAction, MyEnvironment> { state, action, env in
    switch action {
    default: return .none
    }
  }
])

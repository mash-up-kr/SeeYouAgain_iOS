//
//  TabBarCore.swift
//  TabBar
//
//  Created by 안상희 on 2023/05/21.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import ComposableArchitecture

public struct TabBarState: Equatable {
  public init() {}
}

public enum TabBarAction {}

public struct TabBarEnvironment {
  public init() {}
}

public let tabBarReducer = Reducer.combine([
  Reducer<TabBarState, TabBarAction, TabBarEnvironment> { state, action, env in
    switch action {
    default: return .none
    }
  }
])

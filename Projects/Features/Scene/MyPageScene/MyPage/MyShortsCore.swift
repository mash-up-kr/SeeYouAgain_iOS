//
//  MyShortsCore.swift
//  MyPage
//
//  Created by 안상희 on 2023/06/16.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import ComposableArchitecture

public struct MyShorts: Equatable {
  var totalShortsCount: Int
  var shortShortsCount: Int
  var longShortsCount: Int
  
  public init(
    totalShortsCount: Int,
    shortShortsCount: Int,
    longShortsCount: Int
  ) {
    self.totalShortsCount = totalShortsCount
    self.shortShortsCount = shortShortsCount
    self.longShortsCount = longShortsCount
  }
}

public struct MyShortsState: Equatable {
  public var shorts: MyShorts
  
  public init(
    shorts: MyShorts
  ) {
    self.shorts = shorts
  }
}

public enum MyShortsAction {
  case shortShortsButtonTapped
  case longShortsButtonTapped
}

public struct MyShortsEnvironment {
  public init() {}
}

public let myShortsReducer = Reducer.combine([
  Reducer<MyShortsState, MyShortsAction, MyShortsEnvironment> { state, action, env in
    switch action {
    default: return .none
    }
  }
])

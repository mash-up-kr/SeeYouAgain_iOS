//
//  HomeListCore.swift
//  Home
//
//  Created by GREEN on 2023/04/05.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import CombineExt
import ComposableArchitecture
import Models
import Services

public struct HomeState: Equatable {
  
  public init() { }
}

public enum HomeAction: Equatable {
  case moveToSettingButtonTapped
}

public struct HomeEnvironment {
  var userService: UserService
  
  public init(userService: UserService) {
    self.userService = userService
  }
}

public let homeReducer = Reducer.combine([
  Reducer<HomeState, HomeAction, HomeEnvironment> { state, action, env in
    switch action {
    case .moveToSettingButtonTapped:
      return .none
    }
  }
])

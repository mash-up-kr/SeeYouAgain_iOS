//
//  SplashCore.swift
//  Setting
//
//  Created by GREEN on 2023/04/28.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Combine
import ComposableArchitecture
import Foundation
import Models
import Services

public struct SplashState: Equatable {
  public init() { }
}

public enum SplashAction: Equatable {
  // MARK: - Inner Business Action
  case _onAppear
  case _checkConnectHistory
  case _moveToHome
  case _moveToSetCategory
}

public struct SplashEnvironment {
  let userDefaultsService: UserDefaultsService
  let logService: LogService
  
  public init(
    userDefaultsService: UserDefaultsService,
    logService: LogService
  ) {
    self.userDefaultsService = userDefaultsService
    self.logService = logService
  }
}

public let splashReducer = Reducer.combine([
  Reducer<SplashState, SplashAction, SplashEnvironment> { state, action, env in
    switch action {
    case ._onAppear:
      return Effect(value: ._checkConnectHistory)
      
    case ._checkConnectHistory:
      return env.userDefaultsService.load(.registered)
        .map({ status -> SplashAction in
          if status {
            return ._moveToHome
          } else {
            return ._moveToSetCategory
          }
        })
      
    case ._moveToHome:
      return Effect.merge(
        env.logService.attendance().fireAndForget(),
        env.logService.sharing().fireAndForget()
      )
      
    case ._moveToSetCategory:
      return .none
    }
  }
])

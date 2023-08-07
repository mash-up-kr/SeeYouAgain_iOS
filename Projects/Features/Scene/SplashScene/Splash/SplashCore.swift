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
import WatchConnectivity

public struct SplashState: Equatable {
  public init() { }
}

public enum SplashAction: Equatable {
  // MARK: - Inner Business Action
  case _onAppear
  case _checkConnectHistory
  case _moveToHome
  case _moveToSetCategory
  case _sendUserIDToWatch
}

public struct SplashEnvironment {
  let userDefaultsService: UserDefaultsService
  
  public init(userDefaultsService: UserDefaultsService) {
    self.userDefaultsService = userDefaultsService
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
      return Effect(value: ._sendUserIDToWatch)

    case ._moveToSetCategory:
      return Effect(value: ._sendUserIDToWatch)

    case ._sendUserIDToWatch:
      let session = WCSession.default
      if let value = UserDefaults.standard.string(forKey: "userID"), WCSession.isSupported(), session.isReachable {
        session.sendMessage(["userID": value], replyHandler: nil, errorHandler: nil)
      }
      
      return .none
    }
  }
])

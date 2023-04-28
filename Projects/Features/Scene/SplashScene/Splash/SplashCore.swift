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
  // MARK: - User Action
  case viewDidLoad
  
  // MARK: - Inner Business Action
  case _exitSplash
  
  // MARK: - Inner SetState Action
  
  // MARK: - Child Action
}

public struct SplashEnvironment {
}

public let splashReducer = Reducer.combine([
  Reducer<SplashState, SplashAction, SplashEnvironment> { state, action, env in
    switch action {
    case .viewDidLoad:
      // TODO: - 추후 데이터 로드 되는 용도 (데이터 다 받아올 시 exitSplash 액션 방출)
      return .none
      
    case ._exitSplash:
      return .none
    }
  }
])

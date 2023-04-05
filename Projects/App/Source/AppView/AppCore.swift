//
//  AppCore.swift
//  App
//
//  Created by GREEN on 2023/04/05.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import ComposableArchitecture
import Models
import Services

public struct AppState: Equatable {
  
  init() {
  }
}

public enum AppAction {
  case onAppear
}

internal struct AppEnvironment {
  
  internal init() {
  }
}

let appReducer = Reducer<AppState, AppAction, AppEnvironment>.combine([
  Reducer<AppState, AppAction, AppEnvironment> { state, action, env in
    switch action {
    case .onAppear:
      return .none
    }
  }
])

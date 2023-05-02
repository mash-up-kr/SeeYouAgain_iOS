//
//  MainListCore.swift
//  Main
//
//  Created by GREEN on 2023/04/05.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import CombineExt
import ComposableArchitecture
import Models
import Services

public struct MainState: Equatable {
  public init() { }
}

public enum MainAction: Equatable {
}

public struct MainEnvironment {
  public init() {}
}

public let mainReducer = Reducer.combine([
  Reducer<MainState, MainAction, MainEnvironment> { state, action, env in
    switch action {
    default: return .none
    }
  }
])

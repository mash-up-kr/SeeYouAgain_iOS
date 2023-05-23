//
//  MainScreenCore.swift
//  MainCoordinator
//
//  Created by 안상희 on 2023/05/21.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Combine
import ComposableArchitecture
import Main
import TCACoordinators

public enum MainScreenState: Equatable {
  case main(MainState)
}

public enum MainScreenAction {
  case main(MainAction)
}

internal struct MainScreenEnvironment {
  internal init() {}
}

internal let mainScreenReducer = Reducer<
  MainScreenState,
  MainScreenAction,
  MainScreenEnvironment
>.combine([
  mainReducer
    .pullback(
      state: /MainScreenState.main,
      action: /MainScreenAction.main,
      environment: { _ in
        MainEnvironment()
      }
    )
])

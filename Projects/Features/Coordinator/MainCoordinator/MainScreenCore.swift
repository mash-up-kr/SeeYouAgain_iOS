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
import Services
import TCACoordinators

public enum MainScreenState: Equatable {
  case main(MainState)
}

public enum MainScreenAction {
  case main(MainAction)
}

internal struct MainScreenEnvironment {
  fileprivate let categoryService: CategoryService
  
  internal init(categoryService: CategoryService) {
    self.categoryService = categoryService
  }
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
      environment: {
        MainEnvironment(categoryService: $0.categoryService)
      }
    )
])

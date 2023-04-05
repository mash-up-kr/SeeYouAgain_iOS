//
//  MainScreenCore.swift
//  MainCoordinator
//
//  Created by GREEN on 2023/04/05.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import ComposableArchitecture
import Home
import Services
import Setting
import TCACoordinators

public enum MainScreenState: Equatable {
  case home(HomeState)
  case setting(SettingState)
}

public enum MainScreenAction: Equatable {
  case home(HomeAction)
  case setting(SettingAction)
}

internal struct MainScreenEnvironment {
  var userService: UserService
  
  internal init(userService: UserService) {
    self.userService = userService
  }
}

internal let mainScreenReducer = Reducer<
  MainScreenState,
  MainScreenAction,
  MainScreenEnvironment
>.combine([
  homeReducer
    .pullback(
      state: /MainScreenState.home,
      action: /MainScreenAction.home,
      environment: {
        HomeEnvironment(userService: $0.userService)
      }
    ),
  settingReducer
    .pullback(
      state: /MainScreenState.setting,
      action: /MainScreenAction.setting,
      environment: { _ in
        SettingEnvironment()
      }
    ),
])

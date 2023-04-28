//
//  SettingScreenCore.swift
//  Coordinator
//
//  Created by GREEN on 2023/04/28.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import ComposableArchitecture
import Services
import Setting
import TCACoordinators

public enum SettingScreenState: Equatable {
  case setting(SettingState)
}

public enum SettingScreenAction: Equatable {
  case setting(SettingAction)
}

internal struct SettingScreenEnvironment {
}

internal let settingScreenReducer = Reducer<
  SettingScreenState,
  SettingScreenAction,
  SettingScreenEnvironment
>.combine([
  settingReducer
    .pullback(
      state: /SettingScreenState.home,
      action: /SettingScreenAction.home,
      environment: { _ in
        SettingEnvironment()
      }
    ),
])

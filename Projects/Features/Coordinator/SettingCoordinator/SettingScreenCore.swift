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
  let appVersionService: AppVersionService
  
  init(appVersionService: AppVersionService) {
    self.appVersionService = appVersionService
  }
}

internal let settingScreenReducer = Reducer<
  SettingScreenState,
  SettingScreenAction,
  SettingScreenEnvironment
>.combine([
  settingReducer
    .pullback(
      state: /SettingScreenState.setting,
      action: /SettingScreenAction.setting,
      environment: {
        SettingEnvironment(appVersionService: $0.appVersionService)
      }
    )
])

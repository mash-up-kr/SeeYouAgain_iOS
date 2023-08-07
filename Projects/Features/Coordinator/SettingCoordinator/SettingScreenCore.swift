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
  case appVersion(AppVersionState)
  case modeSelection(ModeSelectionState)
  case companySelection(CompanySelectionState)
}

public enum SettingScreenAction: Equatable {
  case setting(SettingAction)
  case appVersion(AppVersionAction)
  case modeSelection(ModeSelectionAction)
  case companySelection(CompanySelectionAction)
}

internal struct SettingScreenEnvironment {
  let appVersionService: AppVersionService
  let userDefaultsService: UserDefaultsService
  
  init(
    appVersionService: AppVersionService,
    userDefaultsService: UserDefaultsService
  ) {
    self.appVersionService = appVersionService
    self.userDefaultsService = userDefaultsService
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
      environment: { _ in SettingEnvironment() }
    ),
  appVersionReducer
    .pullback(
      state: /SettingScreenState.appVersion,
      action: /SettingScreenAction.appVersion,
      environment: { AppVersionEnvironment(appVersionService: $0.appVersionService) }
    ),
  modeSelectionReducer
    .pullback(
      state: /SettingScreenState.modeSelection,
      action: /SettingScreenAction.modeSelection,
      environment: { _ in ModeSelectionEnvironment() }
    ),
  companySelectionReducer
    .pullback(
      state: /SettingScreenState.companySelection,
      action: /SettingScreenAction.companySelection,
      environment: { _ in CompanySelectionEnvironment() }
    )
])

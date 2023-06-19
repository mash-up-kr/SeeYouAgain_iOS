//
//  SettingCore.swift
//  Scene
//
//  Created by GREEN on 2023/04/28.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Combine
import ComposableArchitecture
import Foundation
import Services

public struct SettingState: Equatable {
  var appVersion: String
  var appVersionDescription: String
  
  public init(
    appVersion: String = "",
    appVersionDescription: String = ""
  ) {
    self.appVersion = appVersion
    self.appVersionDescription = appVersionDescription
  }
}

public enum SettingAction: Equatable {
  // MARK: - User Action
  case backButtonTapped
  
  // MARK: - Inner Business Action
  case _onAppear
  case _fetchCurrentAppVersion
  case _fetchLatestAppVersion
  
  // MARK: - Inner SetState Action
  case _setAppVersion(String)
  case _setAppVersionDescription(String)
  
  // MARK: - Child Action
}

public struct SettingEnvironment {
  let appVersionService: AppVersionService
  
  public init(appVersionService: AppVersionService) {
    self.appVersionService = appVersionService
  }
}

public let settingReducer = Reducer.combine([
  Reducer<SettingState, SettingAction, SettingEnvironment> { state, action, env in
    switch action {
    case .backButtonTapped:
      return .none
      
    case ._onAppear:
      return Effect(value: ._fetchCurrentAppVersion)
      
    case ._fetchCurrentAppVersion:
      return env.appVersionService.fetchAppVersion()
        .catchToEffect()
        .flatMapLatest { result -> Effect<SettingAction, Never> in
          switch result {
          case let .success(appVersion):
            return Effect.concatenate([
              Effect(value: ._setAppVersion(appVersion)),
              Effect(value: ._fetchLatestAppVersion),
            ])
            
          case .failure:
            // TODO: - 필요 시 에러 처리 추가 구현
            return Effect(value: ._setAppVersion(""))
          }
        }
        .eraseToEffect()
      
    case ._fetchLatestAppVersion:
      return env.appVersionService.fetchLastestAppVersion(state.appVersion)
        .catchToEffect()
        .flatMapLatest { result -> Effect<SettingAction, Never> in
          switch result {
          case let .success(appVersionDescription):
            return Effect(value: ._setAppVersionDescription(appVersionDescription))
            
          case .failure:
            // TODO: - 필요 시 에러 처리 추가 구현
            return Effect(value: ._setAppVersionDescription(""))
          }
        }
        .eraseToEffect()
      
    case let ._setAppVersion(appVersion):
      state.appVersion = appVersion
      return .none
      
    case let ._setAppVersionDescription(appVersionDiscription):
      state.appVersionDescription = appVersionDiscription
      return .none
    }
  }
])

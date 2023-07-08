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
import UIKit

public struct SettingState: Equatable {
  var appVersion: String
  var appVersionDescription: String
  var isLatestAppVersion: Bool
  var appID: String {
    #if DEBUG
    "6448740360"
    #else
    "6447816671"
    #endif
  }
  
  public init(
    appVersion: String = "",
    appVersionDescription: String = "",
    isLatestAppVersion: Bool = true
  ) {
    self.appVersion = appVersion
    self.appVersionDescription = appVersionDescription
    self.isLatestAppVersion = isLatestAppVersion
  }
}

public enum SettingAction: Equatable {
  // MARK: - User Action
  case backButtonTapped
  case updateButtonTapped
  
  // MARK: - Inner Business Action
  case _onAppear
  case _onDisappear
  case _fetchCurrentAppVersion
  case _fetchLatestAppVersion
  
  // MARK: - Inner SetState Action
  case _setAppVersion(String)
  case _setAppVersionDescription(String)
  case _setIsLatestAppVersion(Bool)
  
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
      
    case .updateButtonTapped:
      guard let url = URL(string: "https://apps.apple.com/app/\(state.appID)") else {
        return .none
      }
      
      UIApplication.shared.open(url)
      return .none
      
    case ._onAppear:
      return Effect(value: ._fetchCurrentAppVersion)
      
    case ._onDisappear:
      return .none
      
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
            return Effect.concatenate([
              Effect(value: ._setAppVersionDescription(appVersionDescription.0)),
              Effect(value: ._setIsLatestAppVersion(appVersionDescription.1)),
            ])
            
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
      
    case let ._setIsLatestAppVersion(isLatestAppVersion):
      state.isLatestAppVersion = isLatestAppVersion
      return .none
    }
  }
])

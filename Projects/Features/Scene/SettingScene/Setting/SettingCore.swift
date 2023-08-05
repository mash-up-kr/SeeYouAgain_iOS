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
  public init() {}
}

public enum SettingAction: Equatable {
  // MARK: - User Action
  case backButtonTapped
  case navigateAppVersion
  // MARK: - Inner Business Action
  
  case _onDisappear
  // MARK: - Inner SetState Action
  
  // MARK: - Child Action
}

public struct SettingEnvironment {  
  public init() {}
}

public let settingReducer = Reducer<
  SettingState,
  SettingAction,
  SettingEnvironment
> { state, action, env in
  switch action {
  case .backButtonTapped:
    return .none
    
  case .navigateAppVersion:
    return .none
    
  case ._onDisappear:
    return .none
  }
}

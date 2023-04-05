//
//  SettingCore.swift
//  Setting
//
//  Created by GREEN on 2023/04/05.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import ComposableArchitecture
import Models
import SwiftUI

public struct SettingState: Equatable {
  
  public init() { }
}

public enum SettingAction: Equatable {
  case backButtonTapped
}

public struct SettingEnvironment {
  
  public init() { }
}

public let settingReducer = Reducer.combine([
  Reducer<SettingState, SettingAction, SettingEnvironment> { state, action, env in
    switch action {
    case .backButtonTapped:
      return .none
    }
  }
])

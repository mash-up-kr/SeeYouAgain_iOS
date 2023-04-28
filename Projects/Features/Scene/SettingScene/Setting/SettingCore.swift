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

public struct SettingState: Equatable {
  public init() { }
}

public enum SettingAction: Equatable {
  // MARK: - User Action
  
  // MARK: - Inner Business Action
  
  // MARK: - Inner SetState Action
  
  // MARK: - Child Action
}

public struct SettingEnvironment {
}

public let settingReducer = Reducer.combine([
  Reducer<SettingState, SettingAction, SettingEnvironment> { state, action, env in
    switch action {
    }
  }
])

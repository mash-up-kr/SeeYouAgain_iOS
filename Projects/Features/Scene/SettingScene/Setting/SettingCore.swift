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
  var nickname: String  // 현재 닉네임
  var updatedNickname: String // 수정 중인 닉네임. 수정이 완료되면 nickname으로 업데이트
  var isEditMode: Bool = false  // 현재 닉네임 변경모드인지 여부
  
  public init(nickname: String) {
    self.nickname = nickname
    self.updatedNickname = nickname
  }
}

public enum SettingAction: Equatable {
  // MARK: - User Action
  case backButtonTapped
  case navigateAppVersion
  case navigateModeSelection
  
  // MARK: - Inner Business Action
  
  // MARK: - Inner SetState Action
  case _setNickname(String)
  case _setIsEditMode(Bool)
  
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
    
  case .navigateModeSelection:
    return .none
    
  case let ._setNickname(nickname):
    return .none
    
  case let ._setIsEditMode(isEditMode):
    state.isEditMode = isEditMode
    return .none
  }
}

//
//  ModeSelectionCore.swift
//  Splash
//
//  Created by 김영균 on 2023/08/06.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Combine
import Common
import ComposableArchitecture
import Foundation
import Services

public struct ModeSelectionState: Equatable {
  var selectedMode: Mode = .basic
  var basicModeIsSelected: Bool {
    return selectedMode == .basic
  }
  var intersestCompanyModeIsSelected: Bool {
    return selectedMode == .interestCompany
  }
  
  public init() {}
}

public enum ModeSelectionAction: Equatable {
  // MARK: - User Action
  case backButtonTapped
  case modeButtonTapped(Mode) // 모드 선택 버튼 클릭 시
  case changeButtonTapped // 변경 버튼 선택 시
  case navigateHome // 일반 모드 선택
  case navigateCompanySelection // 기업 선택 히스토리가 없어 기업 선택 화면으로 이동
  
  // MARK: - Inner Business Action
  case _onAppear
  case _fetchCompanyModeHistory
  
  // MARK: - Inner SetState Action
  case _setCurrentMode(Mode)
}

public struct ModeSelectionEnvironment {
  fileprivate let userDefaultService: UserDefaultsService
  
  public init(userDefaultService: UserDefaultsService = .live) {
    self.userDefaultService = userDefaultService
  }
}

public let modeSelectionReducer: Reducer<
  ModeSelectionState,
  ModeSelectionAction,
  ModeSelectionEnvironment
> = Reducer { state, action, env in
  switch action {
  case .backButtonTapped:
    return .none
    
  case let .modeButtonTapped(mode):
    state.selectedMode = mode
    return .none
    
  case .changeButtonTapped:
    if state.selectedMode == .basic {
      return Effect(value: .navigateHome)
    }
    else {
      return Effect(value: ._fetchCompanyModeHistory)
    }
    
  case .navigateHome:
    return env.userDefaultService.saveCurrentMode(state.selectedMode.rawValue).fireAndForget()
    
  case .navigateCompanySelection:
    return .none
    
  case ._fetchCompanyModeHistory:
    return env.userDefaultService.load(UserDefaultsKey.hasCompanyModeHistory)
      .map { hasHistory -> ModeSelectionAction in
        if hasHistory {
          return .navigateHome
        } else {
          return .navigateCompanySelection
        }
      }
    
  case ._onAppear:
    return env.userDefaultService.fetchCurrentMode()
      .map { mode -> ModeSelectionAction in
        return ._setCurrentMode(mode)
      }
    
  case let ._setCurrentMode(mode):
    state.selectedMode = mode
    return .none
  }
}

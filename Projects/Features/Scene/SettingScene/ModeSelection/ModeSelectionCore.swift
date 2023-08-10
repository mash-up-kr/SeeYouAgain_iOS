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
  var isAlertPresented: Bool = false  // 관심 기업 모드 알럿
  
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
  case _presentAlert
  case _setIsAlertPresented(Bool)
  
  // MARK: - Inner SetState Action
}

public struct ModeSelectionEnvironment {
  public init() { }
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
      return Effect(value: ._presentAlert)
    }
    
  case .navigateHome:
    return .none
    
  case .navigateCompanySelection:
    return .none
    
  case ._onAppear:
    return .none
    
  case ._presentAlert:
    state.isAlertPresented = true
    return .none
    
  case let ._setIsAlertPresented(isPresented):
    state.isAlertPresented = isPresented
    return .none
  }
}

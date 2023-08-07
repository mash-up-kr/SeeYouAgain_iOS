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
  case modeButtonTapped(Mode)
  case changeButtonTapped
  case navigateCompanySelection
  
  // MARK: - Inner Business Action
  case _onAppear
  
  // MARK: - Inner SetState Action
}

public struct ModeSelectionEnvironment {
  public init() {}
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
    return Effect(value: .navigateCompanySelection)
  
  case .navigateCompanySelection:
    return .none
    
  case ._onAppear:
    return .none
  }
}

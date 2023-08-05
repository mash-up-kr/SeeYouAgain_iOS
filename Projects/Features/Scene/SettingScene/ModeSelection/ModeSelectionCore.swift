//
//  ModeSelectionCore.swift
//  Splash
//
//  Created by 김영균 on 2023/08/06.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Combine
import ComposableArchitecture
import Foundation
import Services

public struct ModeSelectionState: Equatable {
  public init() {}
}

public enum ModeSelectionAction: Equatable {
  // MARK: - User Action
  case backButtonTapped
  // MARK: - Inner Business Action
  
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
  }
}

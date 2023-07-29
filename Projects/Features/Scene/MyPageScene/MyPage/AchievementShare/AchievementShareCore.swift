//
//  AchievementShareCore.swift
//  MyPage
//
//  Created by 김영균 on 2023/07/29.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Common
import ComposableArchitecture
import DesignSystem
import Foundation
import Models

public struct AchievementShareState: Equatable {
  var achievementType: AchievementType
  var activityViewIsPresented: Bool
  
  public init(
    achievementType: AchievementType,
    activityViewIsPresented: Bool = false
  ) {
    self.achievementType = achievementType
    self.activityViewIsPresented = activityViewIsPresented
  }
}

public enum AchievementShareAction {
  // MARK: - User Action
  case dismissButtonDidTapped
  case shareButtonDidTapped
  
  // MARK: - Inner SetState Action
  case _setActivityViewIsPresented(Bool)
}

public struct AchievementShareEnvironment {
  public init() {}
}

public let achievementShareReducer = Reducer<
  AchievementShareState,
  AchievementShareAction,
  AchievementShareEnvironment
> { state, action, environment in
  switch action {
  case .dismissButtonDidTapped:
    return .none
    
  case .shareButtonDidTapped:
    return Effect(value: ._setActivityViewIsPresented(true))
    
  case let ._setActivityViewIsPresented(isPresented):
    state.activityViewIsPresented = isPresented
    return .none
  }
}

//
//  MyAchievementsCore.swift
//  Splash
//
//  Created by 김영균 on 2023/07/29.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Common
import ComposableArchitecture
import Foundation
import Models
import Services

public struct MyAchievementsState: Equatable {
  var achievements: [Achievement]
  
  public init(achievements: [Achievement]) {
    self.achievements = achievements
  }
}

public enum MyAchievementsAction {
  // MARK: - User Action
  case achievementBadgeTapped(Achievement)
  
  // MARK: - Inner Business Action
  case _presentAchievementBottomSheet(Achievement)
  case _presentAchievementShareScreen(Achievement)
}

public struct MyAchievementsEnvironment {
  let mainQueue: AnySchedulerOf<DispatchQueue>
  let myPageService: MyPageService
  
  public init(
    mainQueue: AnySchedulerOf<DispatchQueue>,
    myPageService: MyPageService
  ) {
    self.mainQueue = mainQueue
    self.myPageService = myPageService
  }
}

public let myAchievementsReducer = Reducer<
  MyAchievementsState,
  MyAchievementsAction,
  MyAchievementsEnvironment
> { state, action, environment in
  switch action {
  case let .achievementBadgeTapped(achievement):
    if achievement.isAchieved {
      return Effect(value: ._presentAchievementShareScreen(achievement))
    } else {
      return Effect(value: ._presentAchievementBottomSheet(achievement))
    }
    
  default:
    return .none
  }
}

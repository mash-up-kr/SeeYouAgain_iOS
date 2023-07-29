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
  var badges = AchievementType.allCases
  public init() {}
}

public enum MyAchievementsAction {
  // MARK: - User Action
  case achievementBadgeTapped(AchievementType)
  
  // MARK: - Inner Business Action
  case _onAppear
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
  case .achievementBadgeTapped:
    return .none
    
  case ._onAppear:
    return .none
  }
}

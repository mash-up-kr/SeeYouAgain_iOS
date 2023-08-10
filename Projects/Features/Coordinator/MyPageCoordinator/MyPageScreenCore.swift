//
//  MyPageScreenCore.swift
//  MyPageCoordinator
//
//  Created by 안상희 on 2023/05/22.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Combine
import ComposableArchitecture
import Foundation
import LongStorageCoordinator
import MyPage
import Services
import SettingCoordinator
import ShortStorageCoordinator

public enum MyPageScreenState: Equatable {
  case myPage(MyPageState)
  case shortStorage(ShortStorageCoordinatorState)
  case longStorage(LongStorageCoordinatorState)
  case setting(SettingCoordinatorState)
  case achievementShare(AchievementShareState)
}

public enum MyPageScreenAction {
  case myPage(MyPageAction)
  case shortStorage(ShortStorageCoordinatorAction)
  case longStorage(LongStorageCoordinatorAction)
  case setting(SettingCoordinatorAction)
  case achievementShare(AchievementShareAction)
}

internal struct MyPageScreenEnvironment {
  let mainQueue: AnySchedulerOf<DispatchQueue>
  let appVersionService: AppVersionService
  let myPageService: MyPageService
  let logService: LogService
  
  internal init(
    mainQueue: AnySchedulerOf<DispatchQueue>,
    appVersionService: AppVersionService,
    myPageService: MyPageService,
    logService: LogService
  ) {
    self.mainQueue = mainQueue
    self.appVersionService = appVersionService
    self.myPageService = myPageService
    self.logService = logService
  }
}

internal let myPageScreenReducer = Reducer<
  MyPageScreenState,
  MyPageScreenAction,
  MyPageScreenEnvironment
>.combine([
  myPageReducer
    .pullback(
      state: /MyPageScreenState.myPage,
      action: /MyPageScreenAction.myPage,
      environment: {
        MyPageEnvironment(
          mainQueue: $0.mainQueue,
          myPageService: $0.myPageService
        )
      }
    ),
  achievementShareReducer
    .pullback(
      state: /MyPageScreenState.achievementShare,
      action: /MyPageScreenAction.achievementShare,
      environment: { AchievementShareEnvironment(logService: $0.logService) }
    ),
  shortStorageCoordinatorReducer
    .pullback(
      state: /MyPageScreenState.shortStorage,
      action: /MyPageScreenAction.shortStorage,
      environment: {
        ShortStorageCoordinatorEnvironment(
          mainQueue: $0.mainQueue,
          myPageService: $0.myPageService
        )
      }
    ),
  longStorageCoordinatorReducer
    .pullback(
      state: /MyPageScreenState.longStorage,
      action: /MyPageScreenAction.longStorage,
      environment: {
        LongStorageCoordinatorEnvironment(
          mainQueue: $0.mainQueue,
          myPageService: $0.myPageService
        )
      }
    ),
  settingCoordinatorReducer
    .pullback(
      state: /MyPageScreenState.setting,
      action: /MyPageScreenAction.setting,
      environment: {
        SettingCoordinatorEnvironment(appVersionService: $0.appVersionService)
      }
    )
])

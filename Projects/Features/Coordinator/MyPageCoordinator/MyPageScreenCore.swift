//
//  MyPageScreenCore.swift
//  MyPageCoordinator
//
//  Created by 안상희 on 2023/05/22.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Combine
import ComposableArchitecture
import LongStorageCoordinator
import MyPage
import SettingCoordinator
import ShortStorageCoordinator

public enum MyPageScreenState: Equatable {
  case myPage(MyPageState)
  case shortStorage(ShortStorageCoordinatorState)
  case longStorage(LongStorageCoordinatorState)
  case setting(SettingCoordinatorState)
}

public enum MyPageScreenAction {
  case myPage(MyPageAction)
  case shortStorage(ShortStorageCoordinatorAction)
  case longStorage(LongStorageCoordinatorAction)
  case setting(SettingCoordinatorAction)
}

internal struct MyPageScreenEnvironment {
  internal init() {}
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
      environment: { _ in
        MyPageEnvironment()
      }
    ),
  shortStorageCoordinatorReducer
    .pullback(
      state: /MyPageScreenState.shortStorage,
      action: /MyPageScreenAction.shortStorage,
      environment: { _ in
        ShortStorageCoordinatorEnvironment()
      }
    ),
  longStorageCoordinatorReducer
    .pullback(
      state: /MyPageScreenState.longStorage,
      action: /MyPageScreenAction.longStorage,
      environment: { _ in
        LongStorageCoordinatorEnvironment()
      }
    ),
  settingCoordinatorReducer
    .pullback(
      state: /MyPageScreenState.setting,
      action: /MyPageScreenAction.setting,
      environment: { _ in
        SettingCoordinatorEnvironment()
      }
    )
])

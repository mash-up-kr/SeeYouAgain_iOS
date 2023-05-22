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
import ShortStorageCoordinator

public enum MyPageScreenState: Equatable {
  case shortStorage(ShortStorageCoordinatorState)
  case longStorage(LongStorageCoordinatorState)
}

public enum MyPageScreenAction {
  case shortStorage(ShortStorageCoordinatorAction)
  case longStorage(LongStorageCoordinatorAction)
}

internal struct MyPageScreenEnvironment {
  internal init() {}
}

internal let myPageScreenReducer = Reducer<
  MyPageScreenState,
  MyPageScreenAction,
  MyPageScreenEnvironment
>.combine([
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
    )
])

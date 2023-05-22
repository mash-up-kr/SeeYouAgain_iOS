//
//  MyScreenCore.swift
//  MyCoordinator
//
//  Created by 안상희 on 2023/05/22.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Combine
import ComposableArchitecture
import LongStorageCoordinator
import ShortStorageCoordinator

public enum MyScreenState: Equatable {
  case shortStorage(ShortStorageCoordinatorState)
  case longStorage(LongStorageCoordinatorState)
}

public enum MyScreenAction {
  case shortStorage(ShortStorageCoordinatorAction)
  case longStorage(LongStorageCoordinatorAction)
}

internal struct MyScreenEnvironment {
  internal init() {}
}

internal let myScreenReducer = Reducer<
  MyScreenState,
  MyScreenAction,
  MyScreenEnvironment
>.combine([
  shortStorageCoordinatorReducer
    .pullback(
      state: /MyScreenState.shortStorage,
      action: /MyScreenAction.shortStorage,
      environment: { _ in
        ShortStorageCoordinatorEnvironment()
      }
    ),
  longStorageCoordinatorReducer
    .pullback(
      state: /MyScreenState.longStorage,
      action: /MyScreenAction.longStorage,
      environment: { _ in
        LongStorageCoordinatorEnvironment()
      }
    )
])

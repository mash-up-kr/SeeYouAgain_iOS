//
//  HotKeywordScreenCore.swift
//  Coordinator
//
//  Created by GREEN on 2023/04/28.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import ComposableArchitecture
import Dispatch
import HotKeyword
import LongStorageCoordinator
import Services
import TCACoordinators

public enum HotKeywordScreenState: Equatable {
  case hotKeyword(HotKeywordState)
  case longStorage(LongStorageCoordinatorState)
}

public enum HotKeywordScreenAction: Equatable {
  case hotKeyword(HotKeywordAction)
  case longStorage(LongStorageCoordinatorAction)
}

internal struct HotKeywordScreenEnvironment {
  let mainQueue: AnySchedulerOf<DispatchQueue>
  let hotKeywordService: HotKeywordService
  
  internal init(
    mainQueue: AnySchedulerOf<DispatchQueue>,
    hotKeywordService: HotKeywordService
  ) {
    self.mainQueue = mainQueue
    self.hotKeywordService = hotKeywordService
  }
}

internal let hotKeywordScreenReducer = Reducer<
  HotKeywordScreenState,
  HotKeywordScreenAction,
  HotKeywordScreenEnvironment
>.combine([
  hotKeywordReducer
    .pullback(
      state: /HotKeywordScreenState.hotKeyword,
      action: /HotKeywordScreenAction.hotKeyword,
      environment: {
        HotKeywordEnvironment(
          mainQueue: $0.mainQueue,
          hotKeywordService: $0.hotKeywordService
        )
      }
    ),
  longStorageCoordinatorReducer
    .pullback(
      state: /HotKeywordScreenState.longStorage,
      action: /HotKeywordScreenAction.longStorage,
      environment: { _ in
        LongStorageCoordinatorEnvironment()
      }
    ),
])

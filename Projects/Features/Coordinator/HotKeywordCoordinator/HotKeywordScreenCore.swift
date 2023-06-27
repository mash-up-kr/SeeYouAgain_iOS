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
import NewsCardCoordinator
import Services
import TCACoordinators

public enum HotKeywordScreenState: Equatable {
  case hotKeyword(HotKeywordState)
  case newCard(NewsCardCoordinatorState)
}

public enum HotKeywordScreenAction: Equatable {
  case hotKeyword(HotKeywordAction)
  case newCard(NewsCardCoordinatorAction)
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
  newsCardCoordinatorReducer
    .pullback(
      state: /HotKeywordScreenState.newCard,
      action: /HotKeywordScreenAction.newCard,
      environment: { _ in
        NewsCardCoordinatorEnvironment()
      }
    ),
])

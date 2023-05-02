//
//  HotKeywordScreenCore.swift
//  Coordinator
//
//  Created by GREEN on 2023/04/28.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import ComposableArchitecture
import HotKeyword
import HotKeywordNewsList
import Services
import TCACoordinators

public enum HotKeywordScreenState: Equatable {
  case hotKeyword(HotKeywordState)
  case hotKeywordNewsList(HotKeywordNewsListState)
}

public enum HotKeywordScreenAction: Equatable {
  case hotKeyword(HotKeywordAction)
  case hotKeywordNewsList(HotKeywordNewsListAction)
}

internal struct HotKeywordScreenEnvironment {
  internal init() {
    
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
      environment: { _ in
        HotKeywordEnvironment()
      }
    ),
  hotKeywordNewsListReducer
    .pullback(
      state: /HotKeywordScreenState.hotKeywordNewsList,
      action: /HotKeywordScreenAction.hotKeywordNewsList,
      environment: { _ in
        HotKeywordNewsListEnvironment()
      }
    ),
])

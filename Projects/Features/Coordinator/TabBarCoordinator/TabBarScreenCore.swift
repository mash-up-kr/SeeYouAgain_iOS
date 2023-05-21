//
//  TabBarScreenCore.swift
//  Coordinator
//
//  Created by 안상희 on 2023/05/21.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Combine
import ComposableArchitecture
import HotKeywordCoordinator

public enum TabBarScreenState: Equatable {
  case hotKeyword(HotKeywordCoordinatorState)
}

public enum TabBarScreenAction {
  case hotKeyword(HotKeywordCoordinatorAction)
}

internal struct TabBarScreenEnvironment {
  internal init() { }
}

internal let tabBarScreenReducer = Reducer<
  TabBarScreenState,
  TabBarScreenAction,
  TabBarScreenEnvironment
>.combine([
  hotKeywordCoordinatorReducer
    .pullback(
      state: /TabBarScreenState.hotKeyword,
      action: /TabBarScreenAction.hotKeyword,
      environment: { _ in
        HotKeywordCoordinatorEnvironment()
      }
    )
])

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
import MainCoordinator

public enum TabBarScreenState: Equatable {
  case main(MainCoordinatorState)
  case hotKeyword(HotKeywordCoordinatorState)
}

public enum TabBarScreenAction {
  case main(MainCoordinatorAction)
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
  mainCoordinatorReducer
    .pullback(
      state: /TabBarScreenState.main,
      action: /TabBarScreenAction.main,
      environment: { _ in
        MainCoordinatorEnvironment()
      }
    ),
  hotKeywordCoordinatorReducer
    .pullback(
      state: /TabBarScreenState.hotKeyword,
      action: /TabBarScreenAction.hotKeyword,
      environment: { _ in
        HotKeywordCoordinatorEnvironment()
      }
    )
])

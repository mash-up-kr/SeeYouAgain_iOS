//
//  ShortStorageScreenCore.swift
//  Coordinator
//
//  Created by GREEN on 2023/04/28.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import ComposableArchitecture
import Services
import ShortStorageNewsList
import TCACoordinators

public enum ShortStorageScreenState: Equatable {
  case shortStorageNewsList(ShortStorageNewsListState)
}

public enum ShortStorageScreenAction: Equatable {
  case shortStorageNewsList(ShortStorageNewsListAction)
}

internal struct ShortStorageScreenEnvironment {
  internal init() {
    
  }
}

internal let shortStorageScreenReducer = Reducer<
  ShortStorageScreenState,
  ShortStorageScreenAction,
  ShortStorageScreenEnvironment
>.combine([
  shortStorageNewsListReducer
    .pullback(
      state: /ShortStorageScreenState.shortStorageNewsList,
      action: /ShortStorageScreenAction.shortStorageNewsList,
      environment: { _ in
        ShortStorageNewsListEnvironment()
      }
    ),
])

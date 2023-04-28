//
//  LongStorageScreenCore.swift
//  CoordinatorKit
//
//  Created by GREEN on 2023/04/28.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import ComposableArchitecture
import Services
import LongStorageNewsList
import TCACoordinators

public enum LongStorageScreenState: Equatable {
  case longStorageNewsList(LongStorageNewsListState)
}

public enum LongStorageScreenAction: Equatable {
  case longStorageNewsList(LongStorageNewsListAction)
}

internal struct LongStorageScreenEnvironment {
}

internal let longStorageScreenReducer = Reducer<
  LongStorageScreenState,
  LongStorageScreenAction,
  LongStorageScreenEnvironment
>.combine([
  longStorageNewsListReducer
    .pullback(
      state: /LongStorageScreenState.longStorageNewsList,
      action: /LongStorageScreenAction.longStorageNewsList,
      environment: { _ in
        LongStorageNewsListEnvironment()
      }
    ),
])

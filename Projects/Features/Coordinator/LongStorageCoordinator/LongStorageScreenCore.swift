//
//  LongStorageScreenCore.swift
//  CoordinatorKit
//
//  Created by GREEN on 2023/04/28.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import ComposableArchitecture
import LongStorageNewsList
import Services
import TCACoordinators
import Web

public enum LongStorageScreenState: Equatable {
  case longStorageNewsList(LongStorageNewsListState)
  case web(WebState)
}

public enum LongStorageScreenAction: Equatable {
  case longStorageNewsList(LongStorageNewsListAction)
  case web(WebAction)
}

internal struct LongStorageScreenEnvironment {
}

internal let longStorageScreenReducer = Reducer<
  LongStorageScreenState,
  LongStorageScreenAction,
  LongStorageScreenEnvironment
>.combine([
  webReducer
    .pullback(
      state: /LongStorageScreenState.web,
      action: /LongStorageScreenAction.web,
      environment: { _ in
        WebEnvironment()
      }
    ),
  longStorageNewsListReducer
    .pullback(
      state: /LongStorageScreenState.longStorageNewsList,
      action: /LongStorageScreenAction.longStorageNewsList,
      environment: { _ in
        LongStorageNewsListEnvironment()
      }
    )
])

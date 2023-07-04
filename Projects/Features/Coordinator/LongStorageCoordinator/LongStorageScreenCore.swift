//
//  LongStorageScreenCore.swift
//  CoordinatorKit
//
//  Created by GREEN on 2023/04/28.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import ComposableArchitecture
import Foundation
import LongStorageNewsList
import Services
import TCACoordinators

public enum LongStorageScreenState: Equatable {
  case longStorageNewsList(LongStorageNewsListState)
}

public enum LongStorageScreenAction {
  case longStorageNewsList(LongStorageNewsListAction)
}

internal struct LongStorageScreenEnvironment {
  let mainQueue: AnySchedulerOf<DispatchQueue>
  let myPageService: MyPageService
  
  internal init(
    mainQueue: AnySchedulerOf<DispatchQueue>,
    myPageService: MyPageService
  ) {
    self.mainQueue = mainQueue
    self.myPageService = myPageService
  }
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
      environment: {
        LongStorageNewsListEnvironment(
          mainQueue: $0.mainQueue,
          myPageService: $0.myPageService
        )
      }
    )
])

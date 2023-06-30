//
//  ShortStorageScreenCore.swift
//  Coordinator
//
//  Created by GREEN on 2023/04/28.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import ComposableArchitecture
import Foundation
import Services
import ShortStorageNewsList
import TCACoordinators

public enum ShortStorageScreenState: Equatable {
  case shortStorageNewsList(ShortStorageNewsListState)
}

public enum ShortStorageScreenAction {
  case shortStorageNewsList(ShortStorageNewsListAction)
}

internal struct ShortStorageScreenEnvironment {
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

internal let shortStorageScreenReducer = Reducer<
  ShortStorageScreenState,
  ShortStorageScreenAction,
  ShortStorageScreenEnvironment
>.combine([
  shortStorageNewsListReducer
    .pullback(
      state: /ShortStorageScreenState.shortStorageNewsList,
      action: /ShortStorageScreenAction.shortStorageNewsList,
      environment: {
        ShortStorageNewsListEnvironment(
          mainQueue: $0.mainQueue,
          myPageService: $0.myPageService
        )
      }
    )
])

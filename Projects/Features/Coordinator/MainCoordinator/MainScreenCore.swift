//
//  MainScreenCore.swift
//  MainCoordinator
//
//  Created by 안상희 on 2023/05/21.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Combine
import ComposableArchitecture
import Foundation
import Main
import NewsCardCoordinator
import Services
import TCACoordinators

public enum MainScreenState: Equatable {
  case main(MainState)
  case newsCard(NewsCardCoordinatorState)
}

public enum MainScreenAction {
  case main(MainAction)
  case newsCard(NewsCardCoordinatorAction)
}

internal struct MainScreenEnvironment {
  fileprivate let mainQueue: AnySchedulerOf<DispatchQueue>
  fileprivate let userDefaultsService: UserDefaultsService
  fileprivate let newsCardService: NewsCardService
  fileprivate let categoryService: CategoryService
  
  internal init(
    mainQueue: AnySchedulerOf<DispatchQueue>,
    userDefaultsService: UserDefaultsService,
    newsCardService: NewsCardService,
    categoryService: CategoryService
  ) {
    self.mainQueue = mainQueue
    self.userDefaultsService = userDefaultsService
    self.newsCardService = newsCardService
    self.categoryService = categoryService
  }
}

internal let mainScreenReducer = Reducer<
  MainScreenState,
  MainScreenAction,
  MainScreenEnvironment
>.combine([
  mainReducer
    .pullback(
      state: /MainScreenState.main,
      action: /MainScreenAction.main,
      environment: {
        MainEnvironment(
          mainQueue: $0.mainQueue,
          userDefaultsService: $0.userDefaultsService,
          newscardService: $0.newsCardService,
          categoryService: $0.categoryService
        )
      }
    ),
  newsCardCoordinatorReducer
    .pullback(
      state: /MainScreenState.newsCard,
      action: /MainScreenAction.newsCard,
      environment: { _ in
        NewsCardCoordinatorEnvironment()
      }
    )
])

//
//  WatchTodayShortsTabCore.swift
//  Splash
//
//  Created by 리나 on 2023/07/29.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import CommonWatchOS
import ComposableArchitecture
import Foundation
import ModelsWatchOS
import ServicesWatchOS

private enum Constant {
  static let pagingSize: Int = 10
}

public struct WatchTodayShortsTabState: Equatable {
  var fetchIds: Set<FetchID> = []
  var cursorPage: Int = 0
  var cursorDate: Date = .now
  var newsCardList: [NewsCard] = []
  
  public init() { }
}

public enum WatchTodayShortsTabAction {
  case _viewWillAppear
  case _fetchNewsCards(FetchType)
  case _setNewsCards(Result<[NewsCard], Error>, FetchType)
}

public struct WatchTodayShortsTabEnvironment {
  let mainQueue: AnySchedulerOf<DispatchQueue>
  fileprivate let newsCardService: NewsCardService

  public init(
    mainQueue: AnySchedulerOf<DispatchQueue>,
    newsCardService: NewsCardService
  ) {
    self.mainQueue = mainQueue
    self.newsCardService = newsCardService
  }
}

enum FetchID: Hashable, CaseIterable {
  case _fetchCategories
  case _fetchNewsCards
}

public let watchTodayShortsTabReducer = Reducer.combine([
  Reducer<WatchTodayShortsTabState, WatchTodayShortsTabAction, WatchTodayShortsTabEnvironment> { state, action, env in
    switch action {
    case ._viewWillAppear:
      return Effect(value: ._fetchNewsCards(.initial))
      
    case let ._fetchNewsCards(fetchType):
      return env.newsCardService.getAllNewsCards(
        state.cursorDate,
        state.cursorPage,
        Constant.pagingSize
      )
      .catchToEffect()
      .map { WatchTodayShortsTabAction._setNewsCards($0, fetchType) }
      .eraseToEffect()
      
    case let ._setNewsCards(result, fetchType):
      state.fetchIds.remove(FetchID._fetchNewsCards)
      switch result {
        
      case let .success(newsCards):
        state.newsCardList += newsCards
        return . none

      case .failure:
        return .none
      }
    }
  }
])

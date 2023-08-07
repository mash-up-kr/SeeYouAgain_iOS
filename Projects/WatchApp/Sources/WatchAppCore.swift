//
//  WatchAppCore.swift
//  WatchApp
//
//  Created by 리나 on 2023/07/30.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import ComposableArchitecture
import CoreFoundation
import ServicesWatchOS

public struct WatchAppState: Equatable {
  public var watchHotKeywordTab: WatchHotKeywordTabState = .init()
  public var watchTodayShortsTab: WatchTodayShortsTabState = .init()
  public init() {}
}

public enum WatchAppAction {
  case watchHotKeywordTab(WatchHotKeywordTabAction)
  case watchTodayShortsTab(WatchTodayShortsTabAction)
}

public struct WatchAppEnviroment {
  let mainQueue: AnySchedulerOf<DispatchQueue>
  let hotKeywordService: HotKeywordService
  let newsCardService: NewsCardService
  
  public init(
    mainQueue: AnySchedulerOf<DispatchQueue>,
    hotKeywordService: HotKeywordService,
    newsCardService: NewsCardService
  ) {
    self.mainQueue = mainQueue
    self.hotKeywordService = hotKeywordService
    self.newsCardService = newsCardService
  }
}

public let watchAppReducer = Reducer<
  WatchAppState,
  WatchAppAction,
  WatchAppEnviroment
>.combine(
  watchHotKeywordTabReducer
    .pullback(
      state: \.watchHotKeywordTab,
      action: /WatchAppAction.watchHotKeywordTab,
      environment: {
        WatchHotKeywordTabEnvironment(
        mainQueue: $0.mainQueue,
        hotKeywordService: $0.hotKeywordService,
        newsCardService: $0.newsCardService
        )
      }
    ),
  watchTodayShortsTabReducer
    .pullback(
      state: \.watchTodayShortsTab,
      action: /WatchAppAction.watchTodayShortsTab,
      environment: {
          WatchTodayShortsTabEnvironment(
            mainQueue: $0.mainQueue,
            newsCardService: $0.newsCardService
          )
      }
    ),
  Reducer<
    WatchAppState,
    WatchAppAction,
    WatchAppEnviroment
  > { state, action, environment in
    switch action {
    default:
      return .none
    }
  }
)

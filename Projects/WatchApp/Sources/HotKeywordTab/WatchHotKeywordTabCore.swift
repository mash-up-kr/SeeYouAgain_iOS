//
//  WatchHotKeywordTabCore.swift
//  Splash
//
//  Created by 리나 on 2023/07/29.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import ComposableArchitecture
import Foundation
import ServicesWatchOS

private enum Constant {
  static let pagingSize: Int = 2
  static let cursorPage: Int = 0
  static let cursorDate: Date = .now
}

public struct WatchHotKeywordTabState: Equatable {
  var hotKeywordList: [String] = []
  var hotKeywordNewsList: [String] = []
  var subTitleText: String = ""
  var currentKeyword: String = ""
  
  public init() { }
}

public enum WatchHotKeywordTabAction: Equatable {
  case _viewWillApear
  
  case hotKeywordTapped(String)
  case showKeywordDetail(keyword: String, newsList: [String])

  case _fetchData
  case _fetchKeywordNewsList(String)
  case _setHotKeywordList([String])
  case _setSubTitleText(String?)
  case _setHotKeywordNewsList(keyword: String, newsList: [String])
  case _setCurrentKeyword(String)
}

public struct WatchHotKeywordTabEnvironment {
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

public let watchHotKeywordTabReducer = Reducer.combine([
  Reducer<WatchHotKeywordTabState, WatchHotKeywordTabAction, WatchHotKeywordTabEnvironment> { state, action, env in
    switch action {
    case ._viewWillApear:
      return Effect(value: ._fetchData)
      
    case let .hotKeywordTapped(keyword):
      return Effect(value: ._fetchKeywordNewsList(keyword))

    case .showKeywordDetail:
      return .none
      
    case ._fetchData:
      return env.hotKeywordService.fetchHotKeyword()
        .catchToEffect()
        .flatMapLatest { result -> Effect<WatchHotKeywordTabAction, Never> in
          switch result {
          case let .success(hotKeywordDTO):
            return .concatenate([
              Effect(value: ._setSubTitleText(hotKeywordDTO.watchTimeString)),
              Effect(value: ._setHotKeywordList(hotKeywordDTO.ranking))
            ])
            
          case .failure:
            return .none
          }
        }
        .eraseToEffect()
      
    case let ._fetchKeywordNewsList(keyword):
      return env.newsCardService.fetchNews(
        keyword,
        Constant.cursorDate,
        Constant.cursorPage,
        Constant.pagingSize
      )
      .catchToEffect()
      .flatMap { result -> Effect<WatchHotKeywordTabAction, Never> in
        switch result {
        case let .success(news):
          let newsList = news.map { "\($0.press) | \($0.title)" }
          return .concatenate([
            Effect(value: ._setHotKeywordNewsList(keyword: keyword, newsList: newsList)),
            Effect(value: ._setCurrentKeyword(keyword))
          ])

        case .failure:
          return .none
        }
      }
      .eraseToEffect()

    case let ._setHotKeywordList(ranking):
      state.hotKeywordList = ranking
      return .none
      
    case let ._setSubTitleText(subTitle):
      state.subTitleText = subTitle ?? ""
      return .none
      
    case let ._setHotKeywordNewsList(keyword, newsList):
      state.hotKeywordNewsList = newsList
      return Effect(value: .showKeywordDetail(keyword: keyword, newsList: newsList))
      
    case let ._setCurrentKeyword(keyword):
      state.currentKeyword = keyword
      return .none
    }
  }
])

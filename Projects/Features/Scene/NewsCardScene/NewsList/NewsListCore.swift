//
//  NewsListCore.swift
//  Scene
//
//  Created by GREEN on 2023/04/28.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Combine
import ComposableArchitecture
import Foundation
import Models
import Services

public enum SourceType: Equatable {
  case main
  case hot
  case mypage
}

public struct NewsListState: Equatable {
  var source: SourceType
  var shortsId: Int
  var keywordTitle: String
  var newsItems: IdentifiedArrayOf<NewsCardState> = []
  var cursorPage: Int = 0
  var cursorDate: Date = .now
  var pagingSize = 20
  
  public init(
    source: SourceType = .mypage,
    shortsId: Int,
    keywordTitle: String,
    newsItems: IdentifiedArrayOf<NewsCardState> = []
  ) {
    self.source = source
    self.shortsId = shortsId
    self.keywordTitle = keywordTitle
    self.newsItems = newsItems
  }
}

public enum NewsListAction: Equatable {
  // MARK: - User Action
  case backButtonTapped
  case completeButtonTapped
  
  // MARK: - Inner Business Action
  case _onAppear
  case _willDisappear(Int)
  case _completeTodayShorts(Int)
  case _handleNewsResponse(SourceType)
  
  // MARK: - Inner SetState Action
  case _initializeNewsItems
  case _setNewsItems([News])
  
  // MARK: - Child Action
  case newsItem(id: NewsCardState.ID, action: NewsCardAction)
}

public struct NewsListEnvironment {
  fileprivate let newsCardService: NewsCardService
  
  public init(newsCardService: NewsCardService) {
    self.newsCardService = newsCardService
  }
}

public let newsListReducer = Reducer.combine([
  newsCardReducer
    .forEach(
      state: \NewsListState.newsItems,
      action: /NewsListAction.newsItem(id:action:),
      environment: { _ in
        NewsCardEnvironment()
      }
    ),
  Reducer<NewsListState, NewsListAction, NewsListEnvironment> { state, action, env in
    switch action {
    case .backButtonTapped:
      return .none
      
    case .completeButtonTapped:
      return Effect(value: ._completeTodayShorts(state.shortsId))

    case ._onAppear:
      return Effect(value: ._handleNewsResponse(state.source))

    case ._willDisappear:
      return .none
      
    case ._initializeNewsItems:
      state.newsItems.removeAll()
      return .none
      
    case let ._completeTodayShorts(shortsId):
      return env.newsCardService.completeTodayShorts(shortsId)
        .catchToEffect()
        .flatMap { result -> Effect<NewsListAction, Never> in
          switch result {
          case let .success(totalShortsCount):
            return Effect.concatenate([
              Effect(value: ._initializeNewsItems),
              Effect(value: ._willDisappear(totalShortsCount))
            ])
          case .failure:
            return .none
          }
        }
        .eraseToEffect()
      
    case let ._handleNewsResponse(source):
      return handleSourceType(&state, env, source: source)
      
    case let ._setNewsItems(newsItems):
      state.newsItems = IdentifiedArrayOf(uniqueElements: newsItems.map {
        NewsCardState(
          id: $0.id,
          news: News(
            id: $0.id,
            title: $0.title,
            thumbnailImageUrl: $0.thumbnailImageUrl,
            newsLink: $0.newsLink,
            press: $0.press,
            writtenDateTime: $0.writtenDateTime,
            type: $0.type,
            category: $0.category
          )
        )
      })
      return .none
      
    default: return .none
    }
  }
])

private func handleSourceType(
  _ state: inout NewsListState,
  _ env: NewsListEnvironment,
  source: SourceType
) -> Effect<NewsListAction, Never> {
  switch source {
  case .hot:
    var keyword = state.keywordTitle
    keyword.removeFirst()
    
    return env.newsCardService.fetchNews(
      keyword,
      state.cursorDate,
      state.cursorPage,
      state.pagingSize
    )
    .catchToEffect()
    .flatMap { result -> Effect<NewsListAction, Never> in
      switch result {
      case let .success(news):
        let news = news.map { $0.toDomain }
        return Effect(value: ._setNewsItems(news))
      case .failure:
        return .none
      }
    }
    .eraseToEffect()
    
  default:
    return env.newsCardService.getNewsCard(state.shortsId)
      .catchToEffect()
      .flatMap { result -> Effect<NewsListAction, Never> in
        switch result {
        case let .success(news):
          let news = news.map { $0.toDomain }
          return Effect(value: ._setNewsItems(news))
        case .failure:
          return .none
        }
      }
      .eraseToEffect()
  }
}

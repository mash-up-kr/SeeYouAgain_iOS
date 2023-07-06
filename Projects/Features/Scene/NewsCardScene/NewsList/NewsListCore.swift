//
//  NewsListCore.swift
//  Scene
//
//  Created by GREEN on 2023/04/28.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Combine
import Common
import ComposableArchitecture
import Foundation
import Models
import Services

public struct NewsListState: Equatable {
  var source: SourceType
  var shortsId: Int
  var keywordTitle: String
  var newsItems: IdentifiedArrayOf<NewsCardState> = []
  var sortType: SortType
  var sortBottomSheetState: SortBottomSheetState
  var cursorPage: Int = 0
  var cursorDate: Date = .now
  var pagingSize = 20
  
  public init(
    source: SourceType,
    shortsId: Int,
    keywordTitle: String,
    newsItems: IdentifiedArrayOf<NewsCardState> = []
  ) {
    self.source = source
    self.shortsId = shortsId
    self.keywordTitle = keywordTitle
    self.newsItems = newsItems
    self.sortType = .latest
    self.sortBottomSheetState = SortBottomSheetState(sortType: .latest, isPresented: false)
  }
}

public enum NewsListAction {
  // MARK: - User Action
  case backButtonTapped(SourceType)
  case completeButtonTapped
  case showSortBottomSheet
  case navigateWebView(SourceType, Int, String)
  
  // MARK: - Inner Business Action
  case _onAppear
  case _willDisappear(Int)
  case _completeTodayShorts(Int)
  case _handleNewsResponse(SourceType)
  case _sortNewsItems(SortType)
  
  // MARK: - Inner SetState Action
  case _initializeNewsItems
  case _setNewsItems([News])
  case _setSortType(SortType)
  
  // MARK: - Child Action
  case newsItem(id: NewsCardState.ID, action: NewsCardAction)
  case sortBottomSheet(SortBottomSheetAction)
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
  sortBottomSheetReducer
    .pullback(
      state: \.sortBottomSheetState,
      action: /NewsListAction.sortBottomSheet,
      environment: { _ in SortBottomSheetEnvironment() }
    ),
  Reducer<NewsListState, NewsListAction, NewsListEnvironment> { state, action, env in
    switch action {
    case .backButtonTapped:
      return .none
      
    case .completeButtonTapped:
      return Effect(value: ._completeTodayShorts(state.shortsId))
      
    case .showSortBottomSheet:
      return Effect(value: .sortBottomSheet(._setIsPresented(true)))
      
    case .navigateWebView:
      return .none
      
    case ._onAppear:
      return Effect(value: ._handleNewsResponse(state.source))
      
    case ._willDisappear:
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
      
    case let ._sortNewsItems(sortType):
      var sortedNewsItems = state.newsItems
      if sortType == .latest {
        sortedNewsItems.sort(by: { $0.news.writtenDateTime > $1.news.writtenDateTime })
      } else {
        sortedNewsItems.sort(by: { $0.news.writtenDateTime < $1.news.writtenDateTime })
      }
      state.newsItems = sortedNewsItems
      return .none
      
    case ._initializeNewsItems:
      state.newsItems.removeAll()
      return .none
      
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
      
    case let ._setSortType(sortType):
      state.sortType = sortType
      return .none
      
    case let .sortBottomSheet(._sort(sortType)):
      return Effect.concatenate(
        Effect(value: ._setSortType(sortType)),
        Effect(value: ._sortNewsItems(sortType)),
        Effect(value: .sortBottomSheet(._setIsPresented(false)))
      )
      
    case let .newsItem(id, action: ._navigateWebView(url)):
      return Effect(value: .navigateWebView(state.source, id, url))
      
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

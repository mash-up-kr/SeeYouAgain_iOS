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

public struct NewsListState: Equatable {
  var keywordTitle: String
  var newsItems: IdentifiedArrayOf<NewsCardState> = []
  var sortType: SortType
  var sortBottomSheetState: SortBottomSheetState
  
  public init(keywordTitle: String, newsItems: IdentifiedArrayOf<NewsCardState> = []) {
    self.keywordTitle = keywordTitle
    self.newsItems = newsItems
    self.sortType = .latest
    self.sortBottomSheetState = SortBottomSheetState(sortType: .latest, isPresented: false)
  }
}

public enum NewsListAction {
  // MARK: - User Action
  case backButtonTapped
  case completeButtonTapped
  case showSortBottomSheet
  
  // MARK: - Inner Business Action
  case _onAppear
  case _willDisappear
  case _sortNewsItems(SortType)
  
  // MARK: - Inner SetState Action
  case _initializeNewsItems
  case _setSortType(SortType)
  
  // MARK: - Child Action
  case newsItem(id: NewsCardState.ID, action: NewsCardAction)
  case sortBottomSheet(SortBottomSheetAction)
}

public struct NewsListEnvironment {
  public init() {}
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
      return Effect.concatenate([
        Effect(value: ._initializeNewsItems),
        Effect(value: ._willDisappear)
      ])
      
    case .showSortBottomSheet:
      return Effect(value: .sortBottomSheet(._setIsPresented(true)))
      
    case ._onAppear:
      /* 임시 데이터 안들어가게 잠시 주석해놨습니다
      state.newsItems = [
        NewsCardState(
          id: 0,
          news: News(
            id: 0,
            title: "“따박따박 이자 받는게 최고야”...마음 편안한 예금, 금리 4% 재진입",
            thumbnailImageUrl: nil,
            newsLink: "https://naver.com",
            press: "매시업",
            writtenDateTime: "2023.06.03 04:24",
            type: "경제"
          )
        ),
        NewsCardState(
          id: 1,
          news: News(
            id: 1,
            title: "“따박따박 이자 받는게 최고야”...마음 편안한 예금, 금리 4% 재진입",
            thumbnailImageUrl: "https://static.mk.co.kr/facebook_mknews.jpg",
            newsLink: "https://naver.com",
            press: "매시업",
            writtenDateTime: "2023.06.03 04:24",
            type: "경제"
          )
        ),
        NewsCardState(
          id: 2,
          news: News(
            id: 2,
            title: "2222뉴스제목입니당",
            thumbnailImageUrl: "https://static.mk.co.kr/facebook_mknews.jpg",
            newsLink: "https://naver.com",
            press: "매시업",
            writtenDateTime: "2023.06.03 04:24",
            type: "경제"
          )
        ),
        NewsCardState(
          id: 3,
          news: News(
            id: 3,
            title: "3333뉴스제목입니당",
            thumbnailImageUrl: "https://static.mk.co.kr/facebook_mknews.jpg",
            newsLink: "https://naver.com",
            press: "매시업",
            writtenDateTime: "2023.06.03 04:24",
            type: "경제"
          )
        ),
        NewsCardState(
          id: 4,
          news: News(
            id: 4,
            title: "4444뉴스제목입니당",
            thumbnailImageUrl: "https://static.mk.co.kr/facebook_mknews.jpg",
            newsLink: "https://naver.com",
            press: "매시업",
            writtenDateTime: "2023.06.23 04:24",
            type: "경제"
          )
        ),
        NewsCardState(
          id: 5,
          news: News(
            id: 5,
            title: "5555뉴스제목입니당",
            thumbnailImageUrl: "https://static.mk.co.kr/facebook_mknews.jpg",
            newsLink: "https://naver.com",
            press: "매시업",
            writtenDateTime: "2023.06.25 04:24",
            type: "경제"
          )
        )
      ]
       */
      return .none
      
    case ._willDisappear:
      return .none
      
    case let ._sortNewsItems(sortType):
      // TODO: 정렬
      /*
      var sortedNewsItems = state.newsItems
      if sortType == .latest {
        sortedNewsItems.sort(by: { $0.writtenDateTime > $1.writtenDateTime })
      } else {
        sortedNewsItems.sort(by: { $0.writtenDateTime < $1.writtenDateTime })
      }
      state.newsItems = sortedNewsItems
      */
      return .none
      
      
    case ._initializeNewsItems:
      state.newsItems.removeAll()
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
      
    default: return .none
    }
  }
])

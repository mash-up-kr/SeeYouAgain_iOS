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

public struct NewsListState: Equatable {
  var keywordTitle: String
  var newsItems: IdentifiedArrayOf<NewsCardState> = []
  
  public init(
    keywordTitle: String
  ) {
    self.keywordTitle = "#자위대 호위함 #사카이 료 (Sakai Ryo) #이스턴 엔데버23 #부산항 #자위대 호위함 #사카이 료 (Sakai Ryo) #이스턴 엔데버23 #부산항"
  }
}

public enum NewsListAction: Equatable {
  // MARK: - User Action
  case backButtonTapped
  case completeButtonTapped
  
  // MARK: - Inner Business Action
  case _onAppear
  
  // MARK: - Inner SetState Action
  
  // MARK: - Child Action
  case newsItem(id: NewsCardState.ID, action: NewsCardAction)
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
  Reducer<NewsListState, NewsListAction, NewsListEnvironment> { state, action, env in
    switch action {
    case .backButtonTapped:
      return .none
      
    case .completeButtonTapped:
      return .none
      
    case ._onAppear:
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
      return .none
      
    default: return .none
    }
  }
])

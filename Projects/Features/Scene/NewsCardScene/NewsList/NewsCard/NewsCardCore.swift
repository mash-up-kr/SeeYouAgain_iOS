//
//  NewsCardCore.swift
//  NewsList
//
//  Created by 안상희 on 2023/06/24.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Combine
import ComposableArchitecture
import Foundation
import Models
import Web

public struct News: Equatable, Identifiable {
  public let id: Int
  let title: String
  let thumbnailImageUrl: String?
  let newsLink: String
  let press: String
  let writtenDateTime: String
  let type: String
  
  public init(
    id: Int,
    title: String,
    thumbnailImageUrl: String?,
    newsLink: String,
    press: String,
    writtenDateTime: String,
    type: String
  ) {
    self.id = id
    self.title = title
    self.thumbnailImageUrl = thumbnailImageUrl
    self.newsLink = newsLink
    self.press = press
    self.writtenDateTime = writtenDateTime
    self.type = type
  }
}

public struct NewsCardState: Equatable, Identifiable {
  public var id: Int
  var news = News(
    id: 0,
    title: "“따박따박 이자 받는게 최고야”...마음 편안한 예금, 금리 4% 재진입",
    thumbnailImageUrl: nil,
    newsLink: "https://naver.com",
    press: "매일경제",
    writtenDateTime: "2023.06.03 04:24",
    type: "경제"
  )
  
  var web: WebState = WebState(webAddress: "https://naver.com")
  
  // FIXME: to.상희 hotKeyword랑 연동하기 위한 중간다리 임시로 만들어두었습니다. 확인 부탁드려요!
  public init(id: Int, news: News, web: WebState) {
    self.id = id
    self.news = news
    self.web = web
  }
  
  public init(newsCardsResponseDTO: NewsCardsResponseDTO) {
    self.id = newsCardsResponseDTO.id
    self.news = News(
      id: newsCardsResponseDTO.id,
      title: newsCardsResponseDTO.keywords,
      thumbnailImageUrl: nil,
      newsLink: "https://naver.com",
      press: "매일경제",
      writtenDateTime: newsCardsResponseDTO.crawledDateTime,
      type: newsCardsResponseDTO.category
    )
    self.web = WebState(webAddress: "https://naver.com")
  }
}

public enum NewsCardAction: Equatable {
  // MARK: - User Action
  case rightButtonTapped
  case cardTapped
  
  // MARK: - Inner Business Action
  
  // MARK: - Inner SetState Action
  
  // MARK: - Child Action
  case web(WebAction)
}

public struct NewsCardEnvironment {
  public init() {}
}

public let newsCardReducer = Reducer.combine([
  Reducer<NewsCardState, NewsCardAction, NewsCardEnvironment> { state, action, env in
    switch action {
    default: return .none
    }
  }
])

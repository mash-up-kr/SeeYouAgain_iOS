//
//  LongShortsCardCore.swift
//  LongStorageNewsList
//
//  Created by 안상희 on 2023/06/25.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import ComposableArchitecture
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

public struct LongShortsCardState: Equatable, Identifiable {
  public var id: Int
  var news: News
  var isCardSelectable: Bool
  var isSelected: Bool
  
  public init(
    id: Int,
    news: News,
    isCardSelectable: Bool,
    isSelected: Bool
  ) {
    self.id = id
    self.news = news
    self.isCardSelectable = isCardSelectable
    self.isSelected = isSelected
  }
  
  var web: WebState = WebState(webAddress: "https://naver.com")
}

public enum LongShortsCardAction: Equatable {
  // MARK: - User Action
  case rightButtonTapped
  case cardTapped
  
  // MARK: - Inner Business Action
  
  // MARK: - Inner SetState Action
  
  // MARK: - Child Action
}

public struct LongShortsCardEnvironment {
  public init() {}
}

public let longShortsCardReducer = Reducer<
  LongShortsCardState,
  LongShortsCardAction,
  LongShortsCardEnvironment
>.combine([
  Reducer { state, action, env in
    switch action {
    default: return .none
    }
  }
])

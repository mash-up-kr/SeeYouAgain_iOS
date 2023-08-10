//
//  KeywordNews.swift
//  Models
//
//  Created by 안상희 on 2023/08/10.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Foundation

public struct KeywordNews: Equatable {
  public var numberOfNewsCard: Int
  public var memberShorts: [KeywordNewsCard]
}

public extension KeywordNews {
#if DEBUG
  static let stub = KeywordNews(
    numberOfNewsCard: 1,
    memberShorts: [
      KeywordNewsCard(id: 1, keywords: "1", category: "POLITICS", crawledDateTime: "2023-07-03T20:03:00"),
      KeywordNewsCard(id: 2, keywords: "뉴스2", category: "WORLD", crawledDateTime: "2023-07-03T20:03:00"),
      KeywordNewsCard(id: 3, keywords: "뉴스3", category: "SOCIETY", crawledDateTime: "2023-07-03T20:03:00"),
      KeywordNewsCard(id: 4, keywords: "뉴스4", category: "SCIENCE", crawledDateTime: "2023-07-03T20:03:00"),
      KeywordNewsCard(id: 5, keywords: "뉴스5", category: "CULTURE", crawledDateTime: "2023-07-03T20:03:00"),
      KeywordNewsCard(id: 6, keywords: "뉴스6", category: "ECONOMIC", crawledDateTime: "2023-07-03T20:03:00"),
      KeywordNewsCard(id: 7, keywords: "뉴스7", category: "POLITICS", crawledDateTime: "2023-07-03T20:03:00")
    ]
  )
#endif
}

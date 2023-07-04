//
//  TodayShorts.swift
//  Models
//
//  Created by 안상희 on 2023/06/28.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Foundation

public struct TodayShorts: Equatable {
  public var numberOfShorts: Int
  public var numberOfReadShorts: Int
  public var memberShorts: [TodayNewsCard]
}

public extension TodayShorts {
#if DEBUG
  static let stub = TodayShorts(
    numberOfShorts: 1,
    numberOfReadShorts: 10,
    memberShorts: [
      TodayNewsCard(id: 1, keywords: "11자위대 호위함, 사키이 료", category: "POLITICS", crawledDateTime: "2023-07-03T20:03:00"),
      TodayNewsCard(id: 2, keywords: "22자위대 호위함, 사키이 료", category: "WORLD", crawledDateTime: "2023-07-03T20:03:00"),
      TodayNewsCard(id: 3, keywords: "33자위대 호위함, 사키이 료", category: "SOCIETY", crawledDateTime: "2023-07-03T20:03:00"),
      TodayNewsCard(id: 4, keywords: "44자위대 호위함, 사키이 료", category: "SCIENCE", crawledDateTime: "2023-07-03T20:03:00"),
      TodayNewsCard(id: 5, keywords: "55자위대 호위함, 사키이 료", category: "CULTURE", crawledDateTime: "2023-07-03T20:03:00"),
      TodayNewsCard(id: 6, keywords: "66자위대 호위함, 사키이 료", category: "ECONOMIC", crawledDateTime: "2023-07-03T20:03:00"),
      TodayNewsCard(id: 7, keywords: "77자위대 호위함, 사키이 료", category: "POLITICS", crawledDateTime: "2023-07-03T20:03:00"),
    ]
  )
#endif
}

//
//  Statistics.swift
//  Models
//
//  Created by 안상희 on 2023/07/29.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Foundation

public struct Statistics: Equatable {
  public let weeklyShortsCnt: [String: Int]
  public let categoryOfInterest: [String: Int]?
  public let dateOfShortsRead: DateOfShortsRead
  
  public init(
    weeklyShortsCnt: [String: Int],
    categoryOfInterest: [String: Int]?,
    dateOfShortsRead: DateOfShortsRead
  ) {
    self.weeklyShortsCnt = weeklyShortsCnt
    self.categoryOfInterest = categoryOfInterest
    self.dateOfShortsRead = dateOfShortsRead
  }
}

public struct DateOfShortsRead: Equatable {
  public let lastWeek: [String]
  public let thisWeek: [String]
}

public extension Statistics {
  static let stub: Statistics = .init(
    weeklyShortsCnt: [
      "2024년 1월 1주차" : 3,
      "2024년 1월 2주차" : 4,
      "2023년 12월 4주차" : 1,
      "2023년 12월 5주차" : 2,
    ],
    categoryOfInterest: [
      "total" : 40,
      "POLITICS" : 24,
      "ECONOMIC" : 10,
      "CULTURE" : 2
    ],
    dateOfShortsRead: DateOfShortsRead(
      lastWeek: [
        "2023-07-24",
        "2023-07-26"
      ],
      thisWeek: [
        "2023-07-31",
        "2023-08-01",
        "2023-08-02",
        "2023-08-04",
        "2023-08-05",
        "2023-08-06"
      ]
    )
  )
}

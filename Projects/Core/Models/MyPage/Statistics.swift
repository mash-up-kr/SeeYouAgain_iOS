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
  public let dateOfShortsRead: DateOfShortsRead
  
  public init(
    weeklyShortsCnt: [String: Int],
    dateOfShortsRead: DateOfShortsRead
  ) {
    self.weeklyShortsCnt = weeklyShortsCnt
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
    dateOfShortsRead: DateOfShortsRead(
      lastWeek: [ "2023-07-17" ],
      thisWeek: [
        "2023-07-29",
        "2023-07-30"
      ]
    )
  )
}

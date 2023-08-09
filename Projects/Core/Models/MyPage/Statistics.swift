//
//  Statistics.swift
//  Models
//
//  Created by 안상희 on 2023/07/29.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Foundation

public struct Statistics: Equatable {
  public let weeklyShortsCount: [String: Int]
  public let categoryOfInterest: [String: Int]
  public let dateOfShortsRead: DateOfShortsRead
  
  public init(
    weeklyShortsCount: [String: Int],
    categoryOfInterest: [String: Int],
    dateOfShortsRead: DateOfShortsRead
  ) {
    self.weeklyShortsCount = weeklyShortsCount
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
    weeklyShortsCount: [
      "2023년 8월 3주차": 0,
      "2023년 8월 4주차": 0,
      "2023년 9월 1주차": 0,
      "2023년 9월 2주차": 40
    ],
    categoryOfInterest: [
      "total": 34,
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

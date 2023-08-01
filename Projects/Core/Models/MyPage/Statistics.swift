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
  public let dateOfShortsRead: DateOfShortsRead?
}

public struct DateOfShortsRead: Equatable {
  public let lastWeek: [String]
  public let thisWeek: [String]
}

public extension Statistics {
  #if DEBUG
  static let stub: Statistics = .init(
    weeklyShortsCnt: [
      "7월 1주차" : 1,
      "7월 2주차" : 2,
      "7월 3주차" : 3,
      "7월 4주차" : 4
    ],
    dateOfShortsRead: DateOfShortsRead(
      lastWeek: [ "2023-07-17" ],
      thisWeek: [ "2023-07-29", "2023-07-30" ]
    )
  )
  #endif
}

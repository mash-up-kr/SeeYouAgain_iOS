//
//  StatisticsResponseDTO.swift
//  Models
//
//  Created by 안상희 on 2023/08/01.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Foundation

public struct StatisticsResponseDTO: Decodable {
  public let weeklyShortsCnt: [String: Int]
  public let dateOfShortsRead: DateOfShortsReadListDTO
}

public struct DateOfShortsReadListDTO: Decodable {
  public let lastWeek: [String]
  public let thisWeek: [String]
}

public extension StatisticsResponseDTO {
  var toDomain: Statistics {
    return Statistics(
      weeklyShortsCnt: weeklyShortsCnt,
      dateOfShortsRead: dateOfShortsRead.toDomain
    )
  }
}

public extension DateOfShortsReadListDTO {
  var toDomain: DateOfShortsRead {
    return DateOfShortsRead(
      lastWeek: lastWeek,
      thisWeek: thisWeek
    )
  }
}

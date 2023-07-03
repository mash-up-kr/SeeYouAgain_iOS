//
//  TodayShortsResponseDTO.swift
//  Models
//
//  Created by 안상희 on 2023/06/28.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Foundation

public struct TodayShortsResponseDTO: Decodable {
  let numberOfShorts: Int
  let numberOfReadShorts: Int
  let memberShorts: [NewsCardsResponseDTO]
}

public extension TodayShortsResponseDTO {
  var toDomain: TodayShorts {
    return TodayShorts(
      numberOfShorts: numberOfShorts,
      numberOfReadShorts: numberOfReadShorts,
      memberShorts: memberShorts.map {
        TodayNewsCard(
          id: $0.id,
          keywords: $0.keywords,
          category: $0.category,
          crawledDateTime: $0.crawledDateTime.toDate()
        )
      }
    )
  }
}

fileprivate extension String {
  func toDate() -> Date {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-ddTHH:mm:ss"
    dateFormatter.timeZone = TimeZone(identifier: "UTC")
    
    if let date = dateFormatter.date(from: self) {
      return date
    }
    return Date()
  }
}

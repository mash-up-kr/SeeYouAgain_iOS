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
  let memberShorts: [NewsCardsResponseDTO]
}

public extension TodayShortsResponseDTO {
  var toDomain: TodayShorts {
    return TodayShorts(
      numberOfShorts: numberOfShorts,
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

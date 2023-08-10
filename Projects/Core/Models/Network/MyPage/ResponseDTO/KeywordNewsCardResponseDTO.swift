//
//  KeywordNewsCardResponseDTO.swift
//  Models
//
//  Created by 안상희 on 2023/08/10.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Foundation

public struct KeywordNewsCardResponseDTO: Decodable {
  let numberOfNewsCard: Int
  let memberShorts: [NewsCardsResponseDTO]
}

public extension KeywordNewsCardResponseDTO {
  var toDomain: KeywordNews {
    return KeywordNews(
      numberOfNewsCard: numberOfNewsCard,
      memberShorts: memberShorts.map {
        KeywordNewsCard(
          id: $0.id,
          keywords: $0.keywords,
          category: $0.category,
          crawledDateTime: $0.crawledDateTime
        )
      }
    )
  }
}

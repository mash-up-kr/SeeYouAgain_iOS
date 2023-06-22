//
//  NewsCardsResponseDTO.swift
//  CoreKit
//
//  Created by 김영균 on 2023/06/19.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Common
import Foundation

public struct NewsCardsResponseDTO: Decodable {
  let id: Int
  let keywords: String
  let category: String
  let crawledDateTime: String
}

public extension NewsCardsResponseDTO {
  var toDomain: NewsCard {
    return NewsCard(
      id: id,
      keywords: keywords.components(separatedBy: ","),
      category: CategoryType(uppercasedName: category)!
    )
  }
}

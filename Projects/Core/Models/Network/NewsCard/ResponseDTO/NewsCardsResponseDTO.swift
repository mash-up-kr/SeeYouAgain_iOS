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
  /**
   * - Parameters:
   *   - keywords: NewsCardsResponseDTO의 String가 NewsCard의 [String]으로 변환된 형태.
   *   예시) "시장, 의회, 역사, 결의"를 ["시장", "의회", "역사", "결의"]로 변환된다.
   */
  var toDomain: NewsCard {
    return NewsCard(
      id: id,
      keywords: keywords.replacingOccurrences(of: " ", with: "").components(separatedBy: ","),
      category: CategoryType(uppercasedName: category)!
    )
  }
}

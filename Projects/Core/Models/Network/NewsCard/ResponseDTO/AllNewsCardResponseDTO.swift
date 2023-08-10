//
//  AllNewsCardResponseDTO.swift
//  Core
//
//  Created by 김영균 on 2023/08/10.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Foundation

public struct AllNewsCardResponseDTO: Decodable, Equatable {
  public let homeTitle: String
  public let newsCard: [NewsCardResponseDTO]
}

public struct NewsCardResponseDTO: Decodable, Equatable {
  public let id: Int
  public let keywords: String
  public let category: String
  public let crawledDateTime: String
}

public extension NewsCardResponseDTO {
  /**
   * - Parameters:
   *   - keywords: NewsCardsResponseDTO의 String가 NewsCard의 [String]으로 변환된 형태.
   *   예시) "시장, 의회, 역사, 결의"를 ["시장", "의회", "역사", "결의"]로 변환된다.
   */
  var toDomain: NewsCard {
    return NewsCard(
      id: id,
      keywords: keywords.replacingOccurrences(of: " ", with: "").components(separatedBy: ","),
      category: category
    )
  }
}

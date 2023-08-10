//
//  KeywordNewsCard.swift
//  Models
//
//  Created by 안상희 on 2023/06/28.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Foundation

public struct KeywordNewsCard: Equatable {
  public let id: Int
  public let keywords: String
  public let category: String
  public let crawledDateTime: String
  
  public init(
    id: Int,
    keywords: String,
    category: String,
    crawledDateTime: String
  ) {
    self.id = id
    self.keywords = keywords
    self.category = category
    self.crawledDateTime = crawledDateTime
  }
}

public extension KeywordNewsCard {
#if DEBUG
  static let stub = KeywordNewsCard(
    id: 0,
    keywords: "자위대 호위함, 사키이 료, 이스턴 엔데버23",
    category: "POLITICS",
    crawledDateTime: "2023.07.03. 오후 5:43"
  )
#endif
}

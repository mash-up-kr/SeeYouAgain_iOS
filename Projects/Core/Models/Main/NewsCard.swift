//
//  NewsCard.swift
//  CoreKit
//
//  Created by 김영균 on 2023/06/19.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Foundation

public struct NewsCard: Equatable, Identifiable {
  public let id: Int
  public let keywords: [String]
  public let category: String
  
  public init(id: Int, keywords: [String], category: String) {
    self.id = id
    self.keywords = keywords
    self.category = category
  }
  
  public func hashtagString() -> String {
    return keywords.map { "#\($0)" }.joined(separator: " ")
  }
}

public extension NewsCard {
#if DEBUG
  static let stub = [
    NewsCard(id: 1, keywords: ["자위대 호위함", "사키이 료", "이스턴 엔데버23", "부산항"], category: "POLITICS"),
    NewsCard(id: 2, keywords: ["자위대 호위함", "사키이 료", "이스턴 엔데버23", "부산항"], category: "WORLD"),
    NewsCard(id: 3, keywords: ["자위대 호위함", "사키이 료", "이스턴 엔데버23", "부산항"], category: "SOCIETY"),
    NewsCard(id: 4, keywords: ["자위대 호위함", "사키이 료", "이스턴 엔데버23", "부산항"], category: "SCIENCE"),
    NewsCard(id: 5, keywords: ["자위대 호위함", "사키이 료", "이스턴 엔데버23", "부산항"], category: "CULTURE"),
    NewsCard(id: 6, keywords: ["자위대 호위함", "사키이 료", "이스턴 엔데버23", "부산항"], category: "ECONOMIC"),
  ]
#endif
}

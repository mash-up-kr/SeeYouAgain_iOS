//
//  NewsCard.swift
//  CoreKit
//
//  Created by 김영균 on 2023/06/19.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Foundation

public struct NewsCard: Equatable {
  public let id: Int
  public let keywords: [String]
  public let cateogry: String
}

public extension NewsCard {
  static let stub = [
    NewsCard(id: 1, keywords: ["자위대 호위함", "사키이 료", "이스턴 엔데버23", "부산항"], cateogry: "POLITICS"),
    NewsCard(id: 2, keywords: ["자위대 호위함", "사키이 료", "이스턴 엔데버23", "부산항"], cateogry: "WORLD"),
    NewsCard(id: 3, keywords: ["자위대 호위함", "사키이 료", "이스턴 엔데버23", "부산항"], cateogry: "SOCIETY"),
    NewsCard(id: 4, keywords: ["자위대 호위함", "사키이 료", "이스턴 엔데버23", "부산항"], cateogry: "SCIENCE"),
    NewsCard(id: 5, keywords: ["자위대 호위함", "사키이 료", "이스턴 엔데버23", "부산항"], cateogry: "CULTURE"),
    NewsCard(id: 6, keywords: ["자위대 호위함", "사키이 료", "이스턴 엔데버23", "부산항"], cateogry: "ECONOMIC"),
  ]
}

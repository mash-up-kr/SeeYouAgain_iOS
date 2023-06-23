//
//  NewsCard.swift
//  CoreKit
//
//  Created by 김영균 on 2023/06/19.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Common
import Foundation

public struct NewsCard: Equatable, Identifiable {
  public let id: Int
  public let keywords: [String]
  public let category: CategoryType
}

public extension NewsCard {
#if DEBUG
  static let stub = [
    NewsCard(id: 1, keywords: ["자위대 호위함", "사키이 료", "이스턴 엔데버23", "부산항"], category: .politics),
    NewsCard(id: 2, keywords: ["자위대 호위함", "사키이 료", "이스턴 엔데버23", "부산항"], category: .world),
    NewsCard(id: 3, keywords: ["자위대 호위함", "사키이 료", "이스턴 엔데버23", "부산항"], category: .society),
    NewsCard(id: 4, keywords: ["자위대 호위함", "사키이 료", "이스턴 엔데버23", "부산항"], category: .science),
    NewsCard(id: 5, keywords: ["자위대 호위함", "사키이 료", "이스턴 엔데버23", "부산항"], category: .culture),
    NewsCard(id: 6, keywords: ["자위대 호위함", "사키이 료", "이스턴 엔데버23", "부산항"], category: .economic),
  ]
#endif
}

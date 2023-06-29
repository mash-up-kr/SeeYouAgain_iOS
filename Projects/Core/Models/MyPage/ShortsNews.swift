//
//  ShortsNews.swift
//  Models
//
//  Created by 안상희 on 2023/06/29.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Foundation

public struct ShortsNews: Equatable, Identifiable {
  public let id: Int
  public let keywords: String
  public let category: String
  
  public init(id: Int, keywords: String, category: String) {
    self.id = id
    self.keywords = keywords
    self.category = category
  }
}

public extension ShortsNews {
#if DEBUG
  static let stub = [
    ShortsNews(id: 1, keywords: "#자위대 호위함 #사카이 료 (Sakai Ryo) #이스턴 엔데버23 #부산항", category: "POLITICS"),
    ShortsNews(id: 2, keywords: "#자위대 호위함 #사카이 료 (Sakai Ryo) #이스턴 엔데버23 #부산항", category: "WORLD"),
    ShortsNews(id: 3, keywords: "#자위대 호위함 #사카이 료 (Sakai Ryo) #이스턴 엔데버23 #부산항", category: "SOCIETY"),
    ShortsNews(id: 4, keywords: "#자위대 호위함 #사카이 료 (Sakai Ryo) #이스턴 엔데버23 #부산항", category: "SCIENCE"),
    ShortsNews(id: 5, keywords: "#자위대 호위함 #사카이 료 (Sakai Ryo) #이스턴 엔데버23 #부산항", category: "CULTURE"),
    ShortsNews(id: 6, keywords: "#자위대 호위함 #사카이 료 (Sakai Ryo) #이스턴 엔데버23 #부산항", category: "ECONOMIC"),
  ]
#endif
}

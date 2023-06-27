//
//  HotKeywordDTO.swift
//  Models
//
//  Created by lina on 2023/06/18.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Foundation

public struct HotKeywordDTO: Decodable, Equatable {
  public let createdAt: String
  public let ranking: [String]
  
  public init(createdAt: String, ranking: [String]) {
    self.createdAt = createdAt
    self.ranking = ranking
  }
}

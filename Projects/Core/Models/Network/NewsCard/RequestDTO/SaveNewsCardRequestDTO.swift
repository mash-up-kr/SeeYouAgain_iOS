//
//  SaveNewsCardRequestDTO.swift
//  Models
//
//  Created by 김영균 on 2023/06/26.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Foundation

public struct SaveNewsCardRequestDTO: Encodable {
  public var newsCardID: Int
  
  public init(newsCardID: Int) {
    self.newsCardID = newsCardID
  }
  
  enum CodingKeys: String, CodingKey {
    case newsCardID = "newsCardId"
  }
}

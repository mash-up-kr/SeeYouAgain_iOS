//
//  DeleteTodayShortsRequestDTO.swift
//  Models
//
//  Created by 안상희 on 2023/06/29.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Foundation

public struct DeleteTodayShortsRequestDTO: Encodable {
  let shortsIds: [Int]
  
  public init(shortsIds: [Int]) {
    self.shortsIds = shortsIds
  }
  
  enum CodingKeys: String, CodingKey {
    case shortsIds = "newsCardIds"
  }
}

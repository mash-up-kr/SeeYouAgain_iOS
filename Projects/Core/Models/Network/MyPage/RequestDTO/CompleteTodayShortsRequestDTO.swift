//
//  CompleteTodayShortsRequestDTO.swift
//  Models
//
//  Created by 안상희 on 2023/07/03.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Foundation

public struct CompleteTodayShortsRequestDTO: Encodable {
  let newsCardId: Int
  
  public init(newsCardId: Int) {
    self.newsCardId = newsCardId
  }
}

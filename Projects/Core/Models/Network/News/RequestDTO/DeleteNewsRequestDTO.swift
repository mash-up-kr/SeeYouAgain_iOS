//
//  DeleteNewsRequestDTO.swift
//  Models
//
//  Created by 안상희 on 2023/07/05.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Foundation

public struct DeleteNewsRequestDTO: Encodable {
  let newsIds: [Int]
  
  public init(newsIds: [Int]) {
    self.newsIds = newsIds
  }
}

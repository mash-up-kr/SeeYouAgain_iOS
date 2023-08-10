//
//  KeywordNewsCardRequestDTO.swift
//  Models
//
//  Created by 안상희 on 2023/08/10.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Foundation

public struct KeywordNewsCardRequestDTO: Encodable {
  let cursorId: Int
  let size: Int
  let pivot: Pivot
  
  public init(
    cursorId: Int = 1,
    size: Int = 20,
    pivot: Pivot = .desc
  ) {
    self.cursorId = cursorId
    self.size = size
    self.pivot = pivot
  }
}

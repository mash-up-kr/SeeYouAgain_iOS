//
//  HotKeywordNewsCardRequestDTO.swift
//  Models
//
//  Created by 안상희 on 2023/07/08.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Foundation

public struct HotKeywordNewsCardRequestDTO: Encodable {
  let keyword: String
  let targetDateTime: String
  let cursorId: Int
  let size: Int
  
  public init(
    keyword: String,
    targetDateTime: String,
    cursorId: Int,
    size: Int
  ) {
    self.keyword = keyword
    self.targetDateTime = targetDateTime
    self.cursorId = cursorId
    self.size = size
  }
}

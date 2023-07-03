//
//  TodayShortsRequestDTO.swift
//  Models
//
//  Created by 안상희 on 2023/06/28.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Foundation

public struct TodayShortsRequestDTO: Encodable {
  let cursorId: Int
  let size: Int
  
  public init(cursorId: Int, size: Int) {
    self.cursorId = cursorId
    self.size = size
  }
}

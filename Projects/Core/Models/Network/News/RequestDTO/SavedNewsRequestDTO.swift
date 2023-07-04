//
//  SavedNewsRequestDTO.swift
//  Models
//
//  Created by 안상희 on 2023/07/04.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Foundation

public struct SavedNewsRequestDTO: Encodable {
  let targetDate: String
  let cursorWrittenDateTime: String
  let size: Int
  public let pivot: Pivot = .DESC

  public init(
    targetDate: String,
    cursorWrittenDateTime: String = "",
    size: Int = 20
  ) {
    self.targetDate = targetDate
    self.cursorWrittenDateTime = cursorWrittenDateTime
    self.size = size
  }
}

//
//  SavedNewsRequestDTO.swift
//  Models
//
//  Created by 안상희 on 2023/07/04.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Foundation

public struct SavedNewsRequestDTO: Encodable {
  let cursorWrittenDateTime: String
  let size: Int
  public let pivot: Pivot

  public init(
    cursorWrittenDateTime: String = "",
    size: Int = 20,
    pivot: Pivot = .desc
  ) {
    self.cursorWrittenDateTime = cursorWrittenDateTime
    self.size = size
    self.pivot = pivot
  }
}

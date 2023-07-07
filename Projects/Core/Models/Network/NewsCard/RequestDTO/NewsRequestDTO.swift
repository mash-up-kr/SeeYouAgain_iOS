//
//  NewsRequestDTO.swift
//  Models
//
//  Created by 김영균 on 2023/06/28.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Foundation

public struct NewsRequestDTO: Encodable {
  public let cursorWrittenDateTime: String
  public let size: Int
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

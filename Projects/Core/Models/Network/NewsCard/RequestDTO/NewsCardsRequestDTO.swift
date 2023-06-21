//
//  NewsCardsRequestDTO.swift
//  CoreKit
//
//  Created by 김영균 on 2023/06/19.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Foundation

public struct NewsCardsRequestDTO: Encodable {
  let targetDateTime: Date
  let cursorId: Int
  let size: Int
  
  public init(targetDateTime: Date, cursorId: Int, size: Int) {
    self.targetDateTime = targetDateTime
    self.cursorId = cursorId
    self.size = size
  }
}

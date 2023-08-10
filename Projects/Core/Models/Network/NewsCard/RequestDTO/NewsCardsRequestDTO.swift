//
//  NewsCardsRequestDTO.swift
//  CoreKit
//
//  Created by 김영균 on 2023/06/19.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Foundation

public struct NewsCardsRequestDTO: Encodable {
  let targetDateTime: String
  
  public init(targetDateTime: String) {
    self.targetDateTime = targetDateTime
  }
}

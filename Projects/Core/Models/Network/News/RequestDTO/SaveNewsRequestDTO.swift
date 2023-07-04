//
//  SaveNewsRequestDTO.swift
//  Models
//
//  Created by 안상희 on 2023/07/04.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Foundation

public struct SaveNewsRequestDTO: Encodable {
  let newsId: Int
  
  public init(newsId: Int) {
    self.newsId = newsId
  }
}

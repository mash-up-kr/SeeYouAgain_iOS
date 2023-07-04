//
//  CompleteTodayShortsResponseDTO.swift
//  Models
//
//  Created by 안상희 on 2023/07/03.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Foundation

public struct CompleteTodayShortsResponseDTO: Decodable {
  let shortsCount: Int
}

public extension CompleteTodayShortsResponseDTO {
  var toDomain: Int {
    return shortsCount
  }
}

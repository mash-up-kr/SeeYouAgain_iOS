//
//  SavedNewsResponseDTO.swift
//  Models
//
//  Created by 안상희 on 2023/07/04.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Foundation

public struct SavedNewsResponseDTO: Decodable {
  let savedNewsCount: Int
  let memberNewsResponse: [NewsResponseDTO]
}

public extension SavedNewsResponseDTO {
  var toDomain: SavedNewsList {
    return SavedNewsList(
      savedNewsCount: savedNewsCount,
      newsList: memberNewsResponse.map { $0.toDomain }
    )
  }
}

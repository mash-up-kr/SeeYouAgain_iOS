//
//  GetAllCategoriesResponseDTO.swift
//  Models
//
//  Created by 김영균 on 2023/06/21.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Common
import Foundation

public struct GetAllCategoriesResponseDTO: Decodable {
  let categories: [String]
}

public extension GetAllCategoriesResponseDTO {
  var toDomain: [CategoryType] {
    return categories.compactMap { CategoryType(uppercasedName: $0) }
  }
  
  static let stub = GetAllCategoriesResponseDTO(
    categories: ["POLITICS", "WORLD", "SOCIETY", "SCIENCE", "CULTURE", "ECONOMIC"]
  )
}

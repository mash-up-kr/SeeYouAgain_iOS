//
//  GetAllCategoriesResponseDTO.swift
//  Models
//
//  Created by 김영균 on 2023/06/21.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Foundation

public struct GetAllCategoriesResponseDTO: Decodable {
  public let categories: [String]
}

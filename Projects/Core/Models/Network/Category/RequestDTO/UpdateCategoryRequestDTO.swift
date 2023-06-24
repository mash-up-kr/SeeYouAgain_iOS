//
//  UpdateCategoryRequestDTO.swift
//  Models
//
//  Created by 김영균 on 2023/06/21.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Foundation

public struct UpdateCategoryRequestDTO: Encodable {
  let categoryNames: [String]
  
  public init(categoryNames: [String]) {
    self.categoryNames = categoryNames
  }
}

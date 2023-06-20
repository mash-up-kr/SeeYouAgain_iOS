//
//  SaveCategoryDTO.swift
//  Models
//
//  Created by GREEN on 2023/06/14.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

public struct SaveCategoryRequestDTO: Encodable {
  public let categoryNames: [String]
  
  public init(categoryNames: [String]) {
    self.categoryNames = categoryNames
  }
}

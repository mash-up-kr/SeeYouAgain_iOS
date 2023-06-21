//
//  SaveCategoryResponseDTO.swift
//  Models
//
//  Created by GREEN on 2023/06/14.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

public struct SaveCategoryResponseDTO: Decodable {
  public let uniqueId: String
  
  public init(uniqueId: String) {
    self.uniqueId = uniqueId
  }
}

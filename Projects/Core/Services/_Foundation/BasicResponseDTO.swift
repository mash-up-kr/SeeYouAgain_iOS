//
//  BasicResponseDTO.swift
//  Services
//
//  Created by GREEN on 2023/04/05.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Models

public enum BasicResponseDTO {
  public struct ExistData<T: Decodable>: Decodable {
    public var code: String
    public var message: String
    public var data: T
  }
  
  public struct Common: Decodable {
    public var code: String
    public var message: String
  }
}

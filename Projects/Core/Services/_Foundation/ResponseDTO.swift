//
//  ResponseDTO.swift
//  Services
//
//  Created by 김영균 on 2023/05/03.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Foundation

public enum ResponseDTO {
  public struct ExistData<ResponseType: Decodable> {
    public let statusCode: Int
    public let message: String
    public let data: ResponseType
    
    enum CodingKeys: String, CodingKey {
      case data
      case statusCode = "status_code"
      case message
    }
  }
  
  public struct Common {
    public var statusCode: Int
    public var message: String
    
    enum CodingKeys: String, CodingKey {
      case statusCode = "status_code"
      case message
    }
  }
}

extension ResponseDTO.ExistData: Decodable where ResponseType: Decodable {
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    data = try container.decode(ResponseType.self, forKey: .data)
    statusCode = try container.decode(Int.self, forKey: .statusCode)
    message = try container.decode(String.self, forKey: .message)
  }
}

extension ResponseDTO.Common: Decodable {
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    statusCode = try container.decode(Int.self, forKey: .statusCode)
    message = try container.decode(String.self, forKey: .message)
  }
}

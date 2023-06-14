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
    public let data: ResponseType
    
    enum CodingKeys: String, CodingKey {
      case statusCode = "status"
      case data = "result"
    }
  }
  
  public struct ErrorData {
    public var statusCode: Int
    public var error: Error
    
    enum CodingKeys: String, CodingKey {
      case statusCode = "status"
      case error
    }
  }
  
  public struct Error {
    public var code: String
    public var detailMessage: String?
    
    enum CodingKeys: CodingKey {
      case code, detailMessage
    }
  }
}

extension ResponseDTO.ExistData: Decodable where ResponseType: Decodable {
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    statusCode = try container.decode(Int.self, forKey: .statusCode)
    data = try container.decode(ResponseType.self, forKey: .data)
  }
}

extension ResponseDTO.ErrorData: Decodable {
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    statusCode = try container.decode(Int.self, forKey: .statusCode)
    error = try container.decode(ResponseDTO.Error.self, forKey: .error)
  }
}

extension ResponseDTO.Error: Decodable {
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    code = try container.decode(String.self, forKey: .code)
    detailMessage = try container.decodeIfPresent(String.self, forKey: .detailMessage)
  }
}

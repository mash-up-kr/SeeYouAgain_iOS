//
//  EncodingType.swift
//  Services
//
//  Created by 김영균 on 2023/05/08.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Alamofire
import Foundation

public enum EncodingType {
  case jsonBody
  case queryString
}

extension EncodingType: ParameterEncoding {
  public func encode(
    _ urlRequest: URLRequestConvertible,
    with parameters: Parameters?
  ) throws -> URLRequest {
    switch self {
    case .jsonBody:
      return try JSONEncoding.default.encode(urlRequest, with: parameters)
    case .queryString:
      return try URLEncoding.queryString.encode(urlRequest, with: parameters)
    }
  }
}

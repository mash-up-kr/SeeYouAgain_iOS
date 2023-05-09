//
//  UserAPI.swift
//  Services
//
//  Created by GREEN on 2023/04/05.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Alamofire
import Foundation

public enum UserAPI {
  case getUser
}

extension UserAPI: TargetType {
  public var baseURL: URL {
    return URL(string: "https://jsonplaceholder.typicode.com")!
  }
  
  public var path: String {
    switch self {
    case .getUser:
      return "/users"
    }
  }
  
  public var method: HTTPMethod {
    switch self {
    case .getUser:
      return .get
    }
  }
  
  public var task: Task {
    switch self {
    case .getUser:
      return .requestParameters(parameters: ["id": "1"], encoding: .queryString)
    }
  }
  
  public var headers: [String: String]? {
    switch self {
    case .getUser:
      return ["Content-Type": "application/json"]
    }
  }
  
  public var sampleData: Data {
    switch self {
    case .getUser:
      return Data()
    }
  }
}

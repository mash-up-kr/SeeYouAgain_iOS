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

extension UserAPI: Router {
  public var baseURL: URL {
    return URL(string: "API도메인주소")!
  }
  
  public var path: String {
    switch self {
    case .getUser:
      return "경로주소"
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
      return .requestPlain
    }
  }
  
  public var headers: [String: String]? {
    return ["Content-type": "application/json"]
  }
}

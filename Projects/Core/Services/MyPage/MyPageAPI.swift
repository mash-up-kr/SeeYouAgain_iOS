//
//  MyPageAPI.swift
//  Services
//
//  Created by 안상희 on 2023/06/27.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Alamofire
import Foundation

public enum MyPageAPI {
  case getMemberInfo
}

extension MyPageAPI: TargetType {
  public var baseURL: URL {
    return URL(string: "http://3.38.65.72:8080")!
  }
  
  public var path: String {
    switch self {
    case .getMemberInfo:
      return "/v1/member/info"
    }
  }
  
  public var method: HTTPMethod {
    switch self {
    case .getMemberInfo:
      return .get
    }
  }
  
  public var task: Task {
    switch self {
    case .getMemberInfo:
      return .requestPlain
    }
  }
  
  public var sampleData: Data {
    switch self {
    case .getMemberInfo:
      return Data()
    }
  }
}

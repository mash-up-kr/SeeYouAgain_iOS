//
//  LogAPI.swift
//  CoreKit
//
//  Created by 김영균 on 2023/08/03.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Alamofire
import Foundation

public enum LogAPI {
  case attendance
  case sharing
}

extension LogAPI: TargetType {
  public var baseURL: URL {
    return URL(string: "http://3.36.227.253:8080/v1/member/log")!
  }
  
  public var path: String {
    switch self {
    case .attendance:
      return "/attendance"
      
    case .sharing:
      return "/sharing"
    }
  }
  
  public var method: HTTPMethod {
    switch self {
    case .attendance:
      return .post
      
    case .sharing:
      return .post
    }
  }
  
  public var task: Task {
    switch self {
    case .attendance:
      return .requestPlain
      
    case .sharing:
      return .requestPlain
    }
  }
}

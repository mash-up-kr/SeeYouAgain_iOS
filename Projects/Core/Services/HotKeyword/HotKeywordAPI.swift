//
//  HotKeywordAPI.swift
//  CoreKit
//
//  Created by lina on 2023/06/18.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Alamofire
import Foundation
import Models

public enum HotKeywordAPI {
  case fetchHotKeyword
}

extension HotKeywordAPI: TargetType {
  public var baseURL: URL {
    return URL(string: "http://3.38.65.72:8080/v1")!
  }
  
  public var path: String {
    switch self {
    case .fetchHotKeyword:
      return "/hot-keywords"
    }
  }
  
  public var method: HTTPMethod {
    switch self {
    case .fetchHotKeyword:
      return .get
    }
  }
  
  public var task: Task {
    switch self {
    case .fetchHotKeyword:
      let targetTime = DateFormatter.hotKeywordDateFormatter.string(from: Date())
      return .requestParameters(
        parameters: ["targetTime": targetTime],
        encoding: .queryString
      )
    }
  }
  
  public var headers: [String: String]? {
    return ["Content-Type": "application/json;charset=UTF-8"]
  }
}
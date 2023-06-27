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
  case fetchKeywordShorts(keyword: String)
}

extension HotKeywordAPI: TargetType {
  public var baseURL: URL {
    return URL(string: "http://3.38.65.72:8080/v1")!
  }
  
  public var path: String {
    switch self {
    case .fetchHotKeyword:
      return "/hot-keywords"
    case let .fetchKeywordShorts(keyword):
      return "/hot-keywords/\(keyword)"
    }
  }
  
  public var method: HTTPMethod {
    switch self {
    case .fetchHotKeyword, .fetchKeywordShorts:
      return .get
    }
  }
  
  public var task: Task {
    switch self {
    case .fetchHotKeyword:
      return .requestPlain
    case .fetchKeywordShorts:
      return .requestParameters(
        // lina-TODO: parameter 고정으로 가는건지 확인필요
        parameters: ["cursorId": 0, "size": 10],
        encoding: .queryString
      )
    }
  }
  
  public var headers: [String: String]? {
    return ["Content-Type": "application/json;charset=UTF-8"]
  }
}

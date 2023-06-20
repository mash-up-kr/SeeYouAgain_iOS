//
//  CategoryAPI.swift
//  Services
//
//  Created by GREEN on 2023/06/14.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Alamofire
import Foundation
import Models

public enum CategoryAPI {
  case saveCategory(categories: [String])
}

extension CategoryAPI: TargetType {
  public var baseURL: URL {
    return URL(string: "http://3.38.65.72:8080/v1")!
  }
  
  public var path: String {
    switch self {
    case .saveCategory:
      return "/member/category"
    }
  }
  
  public var method: HTTPMethod {
    switch self {
    case .saveCategory:
      return .post
    }
  }
  
  public var task: Task {
    switch self {
    case let .saveCategory(categories):
      let requestBody = SaveCategoryRequestDTO(categoryNames: categories)
      return .requestJSONEncodable(requestBody)
    }
  }
  
  public var headers: [String: String]? {
    switch self {
    case .saveCategory:
      return ["Content-Type": "application/json"]
    }
  }
  
  public var sampleData: Data {
    switch self {
    case .saveCategory:
      return Data()
    }
  }
}

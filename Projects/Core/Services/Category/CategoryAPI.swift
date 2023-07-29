//
//  CategoryAPI.swift
//  Services
//
//  Created by GREEN on 2023/06/14.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Alamofire
import Foundation
#if os(watchOS)
import ModelsWatchOS
#else
import Models
#endif

public enum CategoryAPI {
  case saveCategory(categories: [String])
  case getAllCategories
  case updateCategories(categories: [String])
}

extension CategoryAPI: TargetType {
  public var baseURL: URL {
    return URL(string: "http://3.36.227.253:8080/v1")!
  }
  
  public var path: String {
    switch self {
    case .saveCategory,
      .getAllCategories,
      .updateCategories:
      return "/member/category"
    }
  }
  
  public var method: HTTPMethod {
    switch self {
    case .saveCategory:
      return .post
      
    case .getAllCategories:
      return .get
    
    case .updateCategories:
      return .put
    }
  }
  
  public var task: Task {
    switch self {
    case let .saveCategory(categories):
      let requestBody = SaveCategoryRequestDTO(categoryNames: categories)
      return .requestJSONEncodable(requestBody)
      
    case .getAllCategories:
      return .requestPlain
      
    case let .updateCategories(categories):
      let requestBody = UpdateCategoryRequestDTO(categoryNames: categories)
      return .requestJSONEncodable(requestBody)
    }
  }
  
  public var headers: [String: String]? {
    switch self {
    default:
      return .none
    }
  }
  
  public var sampleData: Data {
    switch self {
    default:
      return Data()
    }
  }
}

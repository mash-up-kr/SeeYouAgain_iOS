//
//  MyPageAPI.swift
//  Services
//
//  Created by 안상희 on 2023/06/27.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Alamofire
import Foundation
import Models

public enum MyPageAPI {
  case getMemberInfo
  case getTodayShorts(Int, Int)
}

extension MyPageAPI: TargetType {
  public var baseURL: URL {
    return URL(string: "http://3.38.65.72:8080/v1")!
  }
  
  public var path: String {
    switch self {
    case .getMemberInfo:
      return "/member/info"
    case .getTodayShorts:
      return "/member-news-card/"
    }
  }
  
  public var method: HTTPMethod {
    switch self {
    case .getMemberInfo:
      return .get
      
    case .getTodayShorts:
      return .get
    }
  }
  
  public var task: Task {
    switch self {
    case .getMemberInfo:
      return .requestPlain
      
    case let .getTodayShorts(cursorId, size):
      let requestDTO = TodayShortsRequestDTO(
        cursorId: cursorId,
        size: size
      )
      return .requestParameters(
        parameters: requestDTO.toDictionary,
        encoding: .queryString
      )
    }
  }
  
  public var sampleData: Data {
    switch self {
    default:
      return Data()
    }
  }
}

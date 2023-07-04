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
  case deleteTodayShorts([Int])
  case fetchSavedNews(String, Int, Pivot)
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
      
    case .deleteTodayShorts:
      return "/member-news-card"
      
    case .fetchSavedNews:
      return "/member-news"
    }
  }
  
  public var method: HTTPMethod {
    switch self {
    case .getMemberInfo:
      return .get
      
    case .getTodayShorts:
      return .get
      
    case .deleteTodayShorts:
      return .post
      
    case .fetchSavedNews:
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
      
    case let .deleteTodayShorts(shortsIds):
      let requestDTO = DeleteTodayShortsRequestDTO(shortsIds: shortsIds)
      return .requestJSONEncodable(requestDTO)
      
    case let .fetchSavedNews(targetDate, size, pivot):
      let requestDTO = SavedNewsRequestDTO(
        targetDate: targetDate,
        size: size,
        pivot: pivot
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

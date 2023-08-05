//
//  MyPageAPI.swift
//  Services
//
//  Created by 안상희 on 2023/06/27.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Alamofire
import Foundation
#if os(watchOS)
import ModelsWatchOS
#else
import Models
#endif

public enum MyPageAPI {
  case getMemberInfo
  case getTodayShorts(Int, Int)
  case deleteTodayShorts([Int])
  case fetchSavedNews(String, Int)
  case deleteSavedNews([Int])
  case getAchievementBadges
}

extension MyPageAPI: TargetType {
  public var baseURL: URL {
    return URL(string: "http://3.36.227.253:8080/v1")!
  }
  
  public var path: String {
    switch self {
    case .getMemberInfo:
      return "/member/info"
      
    case .getTodayShorts:
      return "/member-news-card/saved"
      
    case .deleteTodayShorts:
      return "/member-news-card"
      
    case .fetchSavedNews:
      return "/member-news"
      
    case .deleteSavedNews:
      return "/member/news/bulk-delete"
      
    case .getAchievementBadges:
      return "/member/badge"
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
      
    case .deleteSavedNews:
      return .post
      
    case .getAchievementBadges:
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
      
    case let .fetchSavedNews(targetDate, size):
      let requestDTO = SavedNewsRequestDTO(
        targetDate: targetDate,
        size: size
      )
      return .requestParameters(
        parameters: requestDTO.toDictionary,
        encoding: .queryString
      )
      
    case let .deleteSavedNews(newsIds):
      let requestDTO = DeleteNewsRequestDTO(newsIds: newsIds)
      return .requestJSONEncodable(requestDTO)
      
    case .getAchievementBadges:
      return .requestPlain
    }
  }
  
  public var sampleData: Data {
    switch self {
    default:
      return Data()
    }
  }
}

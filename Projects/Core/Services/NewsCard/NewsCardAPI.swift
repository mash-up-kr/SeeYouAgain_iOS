//
//  NewsCardAPI.swift
//  CoreKit
//
//  Created by 김영균 on 2023/06/19.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Alamofire
import Foundation
import Models

public enum NewsCardAPI {
  case getAllNewsCards(Date, Int, Int)
  case saveNewsCard(Int)
  case getNewsCard(Int)
  case completeTodayShorts(Int)
  case fetchNews(String, Date, Int, Int)
  case saveNews(Int)
}

extension NewsCardAPI: TargetType {
  public var baseURL: URL {
    return URL(string: "http://3.38.65.72:8080/v1")!
  }
  
  public var path: String {
    switch self {
    case .getAllNewsCards:
      return "/member-news-card"
    
    case .saveNewsCard:
      return "/member/news-card"
      
    case let .getNewsCard(newsId):
      return "/news-card/\(newsId)"
      
    case .completeTodayShorts:
      return "/member-news-card"
      
    case let .fetchNews(keyword, _, _, _):
      return "/hot-keywords/\(keyword)"
      
    case .saveNews:
      return "/member/news"
    }
  }
  
  public var method: HTTPMethod {
    switch self {
    case .getAllNewsCards:
      return .get
      
    case .saveNewsCard:
      return .post
      
    case .getNewsCard:
      return .get
      
    case .completeTodayShorts:
      return .delete
      
    case .fetchNews:
      return .get
      
    case .saveNews:
      return .post
    }
  }
  
  public var task: Task {
    switch self {
    case let .getAllNewsCards(targetDateTime, cursorId, pagingSize):
      let requestDTO = NewsCardsRequestDTO(
        targetDateTime: targetDateTime.toFormattedString(format: "yyyy-MM-dd'T'HH:mm:ss"),
        cursorId: cursorId,
        size: pagingSize
      )
      return .requestParameters(
        parameters: requestDTO.toDictionary,
        encoding: .queryString
      )
      
    case let .saveNewsCard(newsCardID):
      let requestDTO = SaveNewsCardRequestDTO(newsCardID: newsCardID)
      return .requestJSONEncodable(requestDTO)
      
    case .getNewsCard:
      return .requestParameters(
        parameters: NewsRequestDTO.init().toDictionary,
        encoding: .queryString
      )
      
    case let .completeTodayShorts(shortsId):
      let requestDTO = CompleteTodayShortsRequestDTO(newsCardId: shortsId)
      return .requestJSONEncodable(requestDTO)
      
    case let .fetchNews(_, targetDateTime, cursorId, pagingSize):
      let requestDTO = NewsCardsRequestDTO(
        targetDateTime: targetDateTime.toFormattedString(format: "yyyy-MM-dd'T'HH:mm:ss"),
        cursorId: cursorId,
        size: pagingSize
      )
      return .requestParameters(
        parameters: requestDTO.toDictionary,
        encoding: .queryString
      )
      
    case let .saveNews(newsId):
      let requestDTO = SaveNewsRequestDTO(newsId: newsId)
      return .requestJSONEncodable(requestDTO)
    }
  }
  
  public var sampleData: Data {
    switch self {
    default:
      return Data()
    }
  }
}

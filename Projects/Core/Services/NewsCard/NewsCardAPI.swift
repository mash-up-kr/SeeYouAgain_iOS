//
//  NewsCardAPI.swift
//  CoreKit
//
//  Created by 김영균 on 2023/06/19.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Alamofire
import Foundation
#if os(watchOS)
import ModelsWatchOS
#else
import Models
#endif

public enum NewsCardAPI {
  case getAllNewsCards(Date, Int, Int)
  case saveNewsCard(Int)
  case getNewsCard(Int)
  case completeTodayShorts(Int)
  case hotkeywordFetchNews(String, Date, Int, Int)
  case saveNews(Int)
  case checkSavedStatus(Int)
  case postNewsRead(Int)
}

extension NewsCardAPI: TargetType {
  public var baseURL: URL {
    switch self {
    case .postNewsRead:
      return URL(string: "http://3.36.227.253:8081/v1")!
    default:
      return URL(string: "http://3.36.227.253:8080/v1")!
    }
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
      
    case .hotkeywordFetchNews:
      return "/news"
      
    case .saveNews:
      return "/member/news"
      
    case let .checkSavedStatus(newsId):
      return "/news/\(newsId)"
      
    case .postNewsRead:
      return "/member/news/read"
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
      
    case .hotkeywordFetchNews:
      return .get
      
    case .saveNews:
      return .post
      
    case .checkSavedStatus:
      return .get
      
    case .postNewsRead:
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
      
    case let .hotkeywordFetchNews(keyword, targetDateTime, cursorId, pagingSize):
      let requestDTO = HotKeywordNewsCardRequestDTO(
        keyword: keyword,
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
      
    case let .checkSavedStatus(newsId):
      return .requestParameters(
        parameters: SaveNewsRequestDTO.init(newsId: newsId).toDictionary,
        encoding: .queryString
      )
      
    case let .postNewsRead(newsId):
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

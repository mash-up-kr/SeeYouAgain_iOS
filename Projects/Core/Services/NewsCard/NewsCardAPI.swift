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
    }
  }
  
  public var method: HTTPMethod {
    switch self {
    case .getAllNewsCards:
      return .get
      
    case .saveNewsCard:
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
      
    case let .saveNewsCard(newsCardId):
      let requestDTO = SaveNewsCardRequestDTO(newsCardId: newsCardId)
      return .requestJSONEncodable(requestDTO)
    }
  }
  
  public var headers: [String: String]? {
    return .none
  }
  
  public var sampleData: Data {
    switch self {
    default:
      return Data()
    }
  }
}

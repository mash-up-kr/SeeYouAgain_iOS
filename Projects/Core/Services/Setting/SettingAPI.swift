//
//  SettingAPI.swift
//  CoreKit
//
//  Created by 김영균 on 2023/08/10.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Alamofire
import Foundation
#if os(watchOS)
import ModelsWatchOS
#else
import Models
#endif

public enum SettingAPI {
  case addInterstCompanies(companies: [String])
  case changeMode(modes: [String])
}

extension SettingAPI: TargetType {
  public var baseURL: URL {
    return URL(string: "http://52.79.171.93:8081/v1")!
  }
  
  public var path: String {
    switch self {
    case .addInterstCompanies:
      return "/member/company"
      
    case .changeMode:
      return "/member/show-mode"
    }
  }
  
  public var method: HTTPMethod {
    switch self {
    case .addInterstCompanies:
      return .post
      
    case .changeMode:
      return .patch
    }
  }
  
  public var task: Task {
    switch self {
    case let .addInterstCompanies(companies):
      let requestBody = AddCompanyReqeustDTO(companies: companies)
      return .requestJSONEncodable(requestBody)
      
    case let .changeMode(modes):
      let requestBody = ChangeModeRequestDTO(showMode: modes)
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

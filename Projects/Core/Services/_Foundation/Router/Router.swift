//
//  Router.swift
//  Services
//
//  Created by GREEN on 2023/04/05.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Alamofire
import Foundation

public protocol Router {
  var baseURL: URL { get }
  var path: String { get }
  var method: HTTPMethod { get }
  var sampleData: Data { get }
  var task: Task { get }
  var headers: [String: String]? { get }
}

public extension Router {
  // stub 데이터가 테스팅에 사용될 때, 기본 데이터는 Data() 입니다.
  var sampleData: Data { .init() }
}

public enum Task {
  // 추가적인 데이터 없는 Request
  case requestPlain
  
  // Encodable 타입의 Body를 설정한 Request
  case requestJSONEncodable(Encodable)
  
  // Encodable 타입의 Body와 custom encoder를 설정한 Request
  case requestCustomJSONEncodable(Encodable, encoder: JSONEncoder)
  
  // encode 된 parameter를 설정한 Request
  case requestParameters(parameters: [String: Any], encoding: ParameterEncoding)
}

//
//  TargetType.swift
//  Services
//
//  Created by 김영균 on 2023/05/03.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Alamofire
import Foundation

public protocol TargetType: URLRequestConvertible {
  
  /// The target's base `URL`.
  var baseURL: URL { get }
  
  /// The HTTP method used in the request.
  var method: HTTPMethod { get }
  
  /// The path to be appended to `baseURL` to form the full `URL`.
  var path: String { get }
  
  /// The headers to be used in the request.
  var headers: [String: String]? { get }
  
  /// Parameters that belongs to the Http header or body. Default is `requestPlain`.
  var task: Task { get }
  
}

public extension TargetType {
  /// Provides stub data for use in testing. Default is `Data()`.
  var sampleData: Data {
    return Data()
  }
}

extension TargetType {
  
  /// Creats a `URLRequest` with the specified `path`, `method`, `header`, `parameters`
  /// or throws if an `Error` was encountered.
  ///
  /// - Returns: A `URLRequest`.
  /// - Throws:  Any error thrown while constructing the `URLRequest`.
  public func asURLRequest() throws -> URLRequest {
    let url = URL(target: self)
    var urlRequest = try URLRequest(url: url, method: method)
    if let headers = headers {
      urlRequest.headers = HTTPHeaders(headers)
    }
    urlRequest = try addParameter(to: urlRequest)
    return urlRequest
  }
  
  /// Add `parameters` to `URLRequest` depending on parameters type.
  ///
  /// - Parameters:
  ///   - to:     The `URLRequest` which the `parameters` will be added.
  /// - Returns:  The `URLRequest` which the `parameters` was added.
  private func addParameter(to request: URLRequest) throws -> URLRequest {
    var request = request
    
    switch task {
    case .requestPlain:
      break
      
    case let .requestParameters(parameters, encoding):
      request = try encoding.encode(request, with: parameters)
      
    case let .requestCompositeParameters(query, body):
      request = try URLEncoding.queryString.encode(request, with: query)
      request = try JSONEncoding.default.encode(request, with: body)
    }
    
    return request
  }
}

fileprivate extension URL {
  
  /// Initialize URL from `TargetType`.
  init<T: TargetType>(target: T) {
    let targetPath = target.path
    if targetPath.isEmpty {
      self = target.baseURL
    } else {
      self = target.baseURL.appendingPathComponent(targetPath)
    }
  }
}

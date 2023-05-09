//
//  NetworkError.swift
//  Services
//
//  Created by 김영균 on 2023/05/04.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Alamofire
import Common
import Foundation

public struct ProviderError: SeeYouAgainError {
  public var code: Code
  public var userInfo: [String: Any]?
  public var underlying: Error?
  public var errorBody: ResponseDTO.Common?
  
  public enum Code: Int {
    case failedRequest = 0
    case isNotSuccessful = 1
    case failedDecode = 2
  }
  
  public init(
    code: ProviderError.Code,
    userInfo: [String: Any]? = nil,
    underlying: Error? = nil,
    response: AFDataResponse<Data>? = nil
  ) {
    self.code = code
    self.userInfo = userInfo
    self.underlying = underlying
    self.userInfo?["response"] = response
    
    if let data = response?.data {
      self.errorBody = try? JSONDecoder().decode(ResponseDTO.Common.self, from: data)
    }
  }
}

public extension SeeYouAgainError {
  func findRouterManagerError() -> ProviderError? {
    var routerManagerError: ProviderError?
    var targetError: (any SeeYouAgainError)? = self
    
    while routerManagerError == nil {
      guard let _targetError = targetError else { return nil }
      
      if let error = _targetError as? ProviderError {
        routerManagerError = error
      } else {
        targetError = _targetError.underlying as? (any SeeYouAgainError)
      }
    }
    
    return routerManagerError
  }
}

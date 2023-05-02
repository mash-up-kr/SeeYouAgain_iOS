//
//  ErrorFactory.swift
//  Common
//
//  Created by GREEN on 2023/04/05.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Foundation

public protocol SeeYouAgainError: CustomNSError {
  var code: Code { get }
  var userInfo: [String: Any]? { get }
  var underlying: Error? { get }
  
  associatedtype Code: RawRepresentable where Code.RawValue == Int
}

extension SeeYouAgainError {
  var errorDomain: String { "\(Self.self)" }
  var errorCode: Int { self.code.rawValue }
  var errorUserInfo: [String: Any]? {
    
    var userInfo: [String: Any] = self.userInfo ?? [:]
    
    userInfo["identifier"] = String(reflecting: code)
    userInfo[NSUnderlyingErrorKey] = underlying
    
    return userInfo
  }
}

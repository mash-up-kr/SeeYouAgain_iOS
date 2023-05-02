//
//  UserService.swift
//  Services
//
//  Created by GREEN on 2023/04/05.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Alamofire
import Common
import ComposableArchitecture
import Foundation
import Models
import XCTestDynamicOverlay

public struct UserService {
  public var fetchUser: () -> Effect<UserDTO, Error>
  
  private init(
    fetchUser: @escaping () -> Effect<UserDTO, Error>
  ) {
    self.fetchUser = fetchUser
  }
}

extension UserService {
  public static let live = Self(
    fetchUser: {
      return RouterManager<UserAPI>
        .init()
        .request(router: .getUser)
        .tryMap({ data -> BasicResponseDTO.ExistData<UserDTO> in
          do {
            return try JSONDecoder()
              .decode(
                BasicResponseDTO.ExistData<UserDTO>.self,
                from: data
              )
          } catch {
            throw UserServiceError(
              code: .decodeFailed,
              userInfo: ["data": data],
              underlying: error
            )
          }
        })
        .map { $0.data }
        .mapError { UserServiceError(code: .getUserFailed, underlying: $0) }
        .eraseToEffect()
    }
  )
  
  public static let unimplemented = Self(
    fetchUser: XCTUnimplemented("\(Self.self).fetchUser")
  )
}

public struct UserServiceError: SeeYouAgainError {
  public var code: Code
  public var userInfo: [String: Any]?
  public var underlying: Error?
  
  public enum Code: Int {
    case decodeFailed = 0
    case getUserFailed = 1
  }
  
  public init(
    code: UserServiceError.Code,
    userInfo: [String: Any]? = nil,
    underlying: Error? = nil
  ) {
    self.code = code
    self.userInfo = userInfo
    self.underlying = underlying
  }
}

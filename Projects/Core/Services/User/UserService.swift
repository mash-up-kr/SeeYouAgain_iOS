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

#if DEBUG
import XCTestDynamicOverlay
#endif

public struct UserService {
  public var fetchUser: () -> Effect<[UserDTO], Error>
  
  private init(
    fetchUser: @escaping () -> Effect<[UserDTO], Error>
  ) {
    self.fetchUser = fetchUser
  }
}

extension UserService {
  public static let live = Self(
    fetchUser: {
      return Provider<UserAPI>
        .init()
        .request(UserAPI.getUser, type: [UserDTO].self)
        .eraseToEffect()
    }
  )
}

#if DEBUG
extension UserService {
  public static let unimplemented = Self(
    fetchUser: XCTUnimplemented("\(Self.self).fetchUser")
  )
}
#endif

//
//  MyPageService.swift
//  Services
//
//  Created by 안상희 on 2023/06/27.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Alamofire
import ComposableArchitecture
import Models

#if DEBUG
import XCTestDynamicOverlay
#endif

public struct MyPageService {
  public var getMemberInfo: () -> Effect<User, Error>
}

extension MyPageService {
  public static let live = Self(
    getMemberInfo: {
      return Provider<MyPageAPI>
        .init()
        .request(
          MyPageAPI.getMemberInfo,
          type: MemberInfoResponseDTO.self
        )
        .compactMap { $0 }
        .map { $0.toDomain }
        .eraseToEffect()
    }
  )
}

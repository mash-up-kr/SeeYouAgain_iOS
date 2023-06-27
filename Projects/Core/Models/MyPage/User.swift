//
//  User.swift
//  Models
//
//  Created by 안상희 on 2023/06/27.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Foundation

public struct User: Equatable {
  public let nickname: String
  public let joinPeriod: Int
  public let totalShortsThisMonth: Int
  public let todayShorts: Int
  public let savedShorts: Int
}

public extension User {
#if DEBUG
  static let stub = [
    User(
      nickname: "똑똑한여행가",
      joinPeriod: 114,
      totalShortsThisMonth: 56,
      todayShorts: 5,
      savedShorts: 56
    )
  ]
#endif
}

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
  
  public init(
    nickname: String,
    joinPeriod: Int,
    totalShortsThisMonth: Int,
    todayShorts: Int,
    savedShorts: Int
  ) {
    self.nickname = nickname
    self.joinPeriod = joinPeriod
    self.totalShortsThisMonth = totalShortsThisMonth
    self.todayShorts = todayShorts
    self.savedShorts = savedShorts
  }
}

public extension User {
  static let stub = User(
    nickname: "똑똑한여행가",
    joinPeriod: 114,
    totalShortsThisMonth: 56,
    todayShorts: 1,
    savedShorts: 16
  )
}

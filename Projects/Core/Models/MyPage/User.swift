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
  public let totalSavedNewsCount: Int
  public let savedNewsCardCount: Int
  public let savedNewsCount: Int
  
  public init(
    nickname: String,
    joinPeriod: Int,
    totalSavedNewsCount: Int,
    savedNewsCardCount: Int,
    savedNewsCount: Int
  ) {
    self.nickname = nickname
    self.joinPeriod = joinPeriod
    self.totalSavedNewsCount = totalSavedNewsCount
    self.savedNewsCardCount = savedNewsCardCount
    self.savedNewsCount = savedNewsCount
  }
}

public extension User {
  static let stub = User(
    nickname: "똑똑한여행가",
    joinPeriod: 114,
    totalSavedNewsCount: 56,
    savedNewsCardCount: 1,
    savedNewsCount: 16
  )
}

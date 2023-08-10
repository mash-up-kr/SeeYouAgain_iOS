//
//  MemberInfoResponseDTO.swift
//  Models
//
//  Created by 안상희 on 2023/06/26.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Foundation

public struct MemberInfoResponseDTO: Decodable {
  let nickname: String
  let joinPeriod: Int
  let totalSavedNewsCount: Int
  let savedNewsCardCount: Int
  let savedNewsCount: Int
}

public extension MemberInfoResponseDTO {
  var toDomain: User {
    return User(
      nickname: nickname,
      joinPeriod: joinPeriod,
      totalSavedNewsCount: totalSavedNewsCount,
      savedNewsCardCount: savedNewsCardCount,
      savedNewsCount: savedNewsCount
    )
  }
}

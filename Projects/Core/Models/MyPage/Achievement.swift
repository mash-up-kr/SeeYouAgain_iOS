//
//  Achievement.swift
//  Models
//
//  Created by 김영균 on 2023/07/29.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Foundation

public struct Achievement: Equatable {
  public let name: String
  public let isAchieved: Bool
  
  public init(
    name: String,
    isAchieved: Bool
  ) {
    self.name = name
    self.isAchieved = isAchieved
  }
}

#if DEBUG
extension Achievement {
  public static let stub: Achievement = .init(name: "김영균", isAchieved: false)
}
#endif

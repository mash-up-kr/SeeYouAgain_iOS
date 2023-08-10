//
//  Achievement.swift
//  Models
//
//  Created by 김영균 on 2023/07/29.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Foundation

public struct Achievement: Equatable {
  public let type: AchievementType
  public let isAchieved: Bool
  
  public init(
    type: AchievementType,
    isAchieved: Bool
  ) {
    self.type = type
    self.isAchieved = isAchieved
  }
}

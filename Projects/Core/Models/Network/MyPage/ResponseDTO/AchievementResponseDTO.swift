//
//  AchievementResponseDTO.swift
//  Core
//
//  Created by 김영균 on 2023/08/04.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Foundation

public struct AchievementResponseDTO: Decodable {
  let threeDaysContinuousAttendance: Bool
  let tenDaysContinuousAttendance: Bool
  let explorer: Bool
  let kingOfSharing: Bool
  let firstAllReadShorts: Bool
  let firstOldShortsSaving: Bool
  let changeMode: Bool
}

public extension AchievementResponseDTO {
  var toDomain: [Achievement] {
    return [
      Achievement(type: .threeDaysContinuousAttendance, isAchieved: threeDaysContinuousAttendance),
      Achievement(type: .tenDaysContinuousAttendance, isAchieved: tenDaysContinuousAttendance),
      Achievement(type: .explorer, isAchieved: explorer),
      Achievement(type: .kingOfSharing, isAchieved: kingOfSharing),
      Achievement(type: .firstAllReadShorts, isAchieved: firstAllReadShorts),
      Achievement(type: .excitedSave, isAchieved: firstOldShortsSaving),
      Achievement(type: .changeMode, isAchieved: changeMode)
    ]
  }
}

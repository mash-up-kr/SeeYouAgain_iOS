//
//  AchievementType.swift
//  CoreKit
//
//  Created by 김영균 on 2023/07/29.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Foundation

public enum AchievementType: String, CaseIterable {
  case threedayResolution = "작심 3일"
  case worldExplorer = "세상 탐험가"
  case joyOfFirstSharing = "첫 공유의 기쁨"
  case longTimeKnowledge = "오래 간직될 지식"
  case firstSaveThrill = "첫 저장의 설렘"
  case halfwayToBegin = "시작이 반"
  case respectForPreferences = "취향존중"
  case regularClient = "단골손님"
}

public extension AchievementType {
  var description: String {
    switch self {
    case .threedayResolution:
      return "숏스에 3일 연속으로\n출석하면 뱃지를 얻을 수 있어요!"
      
    case .worldExplorer:
      return "일주일에 20개 이상 숏스를 읽으면\n뱃지를 얻을 수 있어요!"
      
    case .joyOfFirstSharing:
      return "친구에게 공유를 하면\n뱃지를 얻을 수 있어요!"
      
    case .longTimeKnowledge:
      return "오래 간직할 숏스에 뉴스를 저장하면\n뱃지를 얻을 수 있어요!"
      
    case .firstSaveThrill:
      return "오늘의 숏스에 뉴스를 저장하면\n뱃지를 얻을 수 있어요!"
      
    case .halfwayToBegin:
      return "숏스를 읽으면\n뱃지를 얻을 수 있어요!"
      
    case .respectForPreferences:
      return "관심회사 모드로 설정하셨네요.\n당신의 취향을 존중해요:)"
      
    case .regularClient:
      return "10일 연속으로 출석해\n세상에 대한 지식을 쌓았어요!"
    }
  }
}

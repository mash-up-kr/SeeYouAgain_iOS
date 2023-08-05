//
//  AchievementType.swift
//  CoreKit
//
//  Created by 김영균 on 2023/07/29.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Foundation

public enum AchievementType: String, CaseIterable {
  case threeDaysContinuousAttendance = "작심삼일"
  case explorer = "세상 탐험가"
  case kingOfSharing = "뿌듯한 첫 공유"
  case firstOldShortsSaving = "오래 간직될 지식"
  case firstAllReadShorts = "시작이 반"
  case changeMode = "취향존중"
  case tenDaysContinuousAttendance = "단골손님"
  case none = ""
}

public extension AchievementType {
  var bottomSheetDescription: String {
    switch self {
    case .threeDaysContinuousAttendance:
      return "숏스에 3일 연속으로\n출석하면 뱃지를 얻을 수 있어요!"
      
    case .explorer:
      return "일주일에 20개의 숏스를 읽으면\n뱃지를 얻을 수 있어요!"
      
    case .kingOfSharing:
      return "친구에게 공유를 하면\n뱃지를 얻을 수 있어요!"
      
    case .firstOldShortsSaving:
      return "오래 간직할 숏스에 뉴스를 저장하면\n뱃지를 얻을 수 있어요!"
      
    case .firstAllReadShorts:
      return "숏스를 읽으면\n뱃지를 얻을 수 있어요!"
    
    // TODO: 모드 변경 문구 작성되면 추가 예정
    case .changeMode:
      return ""
      
    case .tenDaysContinuousAttendance:
      return "10일 연속으로 출석하면\n뱃지를 받을 수 있어요!"
      
    case .none:
      return ""
    }
  }
  
  var shareDescription: String {
    switch self {
    case .threeDaysContinuousAttendance:
      return "3일 연속으로 출석해\n세상에 대한 지식을 쌓았어요!"
      
    case .explorer:
      return "20개가 넘는 숏스를 읽은\n당신은 세상탐험가!"
      
    case .kingOfSharing:
      return "친구들에게 내 업적을 자랑했어요!"
      
    case .firstOldShortsSaving:
      return "맘에 드는 뉴스를\n오래 간직할 숏스에 저장했어요."
      
    case .firstAllReadShorts:
      return "처음으로 뉴스를 읽으셨네요!\n앞으로도 숏스를 잘 활용해봐요:)"
      
    case .changeMode:
      return "관심회사 모드로 설정하셨네요.\n당신의 취향을 존중해요:)"
      
    case .tenDaysContinuousAttendance:
      return "10일 연속으로 출석해\n세상에 대한 지식을 쌓았어요!"
      
    case .none:
      return ""
    }
  }
}

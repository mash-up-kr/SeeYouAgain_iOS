//
//  HotKeywordPointList.swift
//  HotKeyword
//
//  Created by lina on 2023/06/15.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Common
import DesignSystem
import Foundation

public struct HotKeywordPointList: Equatable {
  let pointList: [HotKeywordPoint]
  let pattern: HotKeywordPattern
  
  /// 인덱스 숫자가 작을수록 큰 원에 배정됨
  init(hotkeywordList: [String], hotKeywordPattern: HotKeywordPattern) {
    var pointList: [HotKeywordPoint] = []
    
    for (index, cicleData) in hotKeywordPattern.circleDataList.enumerated() {
      pointList.append(HotKeywordPoint(
        keyword: hotkeywordList[safe: index] ?? "",
        circleData: cicleData
      ))
    }
    self.pattern = hotKeywordPattern
    self.pointList = pointList
  }
}

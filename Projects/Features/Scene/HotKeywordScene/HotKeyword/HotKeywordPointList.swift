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
  
  init(hotkeywordList: [String], hotKeywordPattern: HotKeywordPattern) {
    var pointList: [HotKeywordPoint] = []
    
    // TODO: index 접근방식 safe하게 변경
    for (index, keyword) in hotkeywordList.enumerated() {
      pointList.append(HotKeywordPoint(
        keyword: keyword,
        circleData: hotKeywordPattern.circleDataList[index]
      ))
    }
    self.pattern = hotKeywordPattern
    self.pointList = pointList
  }
  
  struct HotKeywordPoint: Equatable, Hashable {
    var x: Double
    var y: Double
    var color: BubbleColor
    var size: BubbleSize
    var keyword: String
    
    init(keyword: String, circleData: HotKeywordPattern.CircleData) {
      self.x = circleData.x
      self.y = circleData.y
      self.color = circleData.color
      self.size = circleData.size
      self.keyword = keyword
    }
  }
}

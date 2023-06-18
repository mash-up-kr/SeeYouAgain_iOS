//
//  HotKeywordPattern.swift
//  HotKeyword
//
//  Created by lina on 2023/06/15.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import DesignSystem
import Foundation

public struct HotKeywordPattern: Equatable {
  let circleDataList: [CircleData]
  
  struct CircleData: Hashable {
    var x: Double
    var y: Double
    var size: BubbleSize
    var color: BubbleColor
  }
}

enum HotKeywordPatternSpace {
  static let patternList = [pattern1, pattern2, pattern3, pattern4]

  /*
   패턴은 피그마에 나와있는 superView를 1500 * 1000으로 확대하여(각 써클들도 확대) 그 위치를 기준으로 x,y 기준점 잡음
   그런데! 서클에 그림자가 있는 부분을 간과하고 확대해서 y 공간 아래 여유를 위해 100을 추가한 상태
   */
  static let pattern1 = HotKeywordPattern(
    circleDataList: [
      HotKeywordPattern.CircleData(x: 242 / 1500, y: 0 / 1100, size: ._240, color: .violet),
      HotKeywordPattern.CircleData(x: 693 / 1500, y: 507 / 1100, size: ._240, color: .lime),
      HotKeywordPattern.CircleData(x: 677 / 1500, y: 124 / 1100, size: ._180, color: .blue),
      HotKeywordPattern.CircleData(x: 290 / 1500, y: 578 / 1100, size: ._180, color: .blue),
      HotKeywordPattern.CircleData(x: 61 / 1500, y: 312 / 1100, size: ._140, color: .white),
      HotKeywordPattern.CircleData(x: 1104 / 1500, y: 422 / 1100, size: ._140, color: .orange),
      HotKeywordPattern.CircleData(x: 505 / 1500, y: 455 / 1100, size: ._120, color: .orange),
      HotKeywordPattern.CircleData(x: 36 / 1500, y: 651 / 1100, size: ._120, color: .green),
      HotKeywordPattern.CircleData(x: 1136 / 1500, y: 133 / 1100, size: ._120, color: .green),
      HotKeywordPattern.CircleData(x: 939 / 1500, y: 42 / 1100, size: ._100, color: .white),
    ]
  )

  static let pattern2 = HotKeywordPattern(
    circleDataList: [
      HotKeywordPattern.CircleData(x: 57 / 1500, y: 18 / 1100, size: ._240, color: .orange),
      HotKeywordPattern.CircleData(x: 571 / 1500, y: 391 / 1100, size: ._240, color: .lime),
      HotKeywordPattern.CircleData(x: 773 / 1500, y: 59 / 1100, size: ._180, color: .blue),
      HotKeywordPattern.CircleData(x: 356 / 1500, y: 661 / 1100, size: ._140, color: .green),
      HotKeywordPattern.CircleData(x: 207 / 1500, y: 497 / 1100, size: ._120, color: .red),
      HotKeywordPattern.CircleData(x: 1107 / 1500, y: 694 / 1100, size: ._120, color: .orange),
      HotKeywordPattern.CircleData(x: 530 / 1500, y: 196 / 1100, size: ._100, color: .white),
      HotKeywordPattern.CircleData(x: 57 / 1500, y: 771 / 1100, size: ._100, color: .violet),
      HotKeywordPattern.CircleData(x: 6 / 1500, y: 499 / 1100, size: ._80, color: .green),
      HotKeywordPattern.CircleData(x: 1049 / 1500, y: 464 / 1100, size: ._80, color: .red),
    ]
  )

  static let pattern3 = HotKeywordPattern(
    circleDataList: [
      HotKeywordPattern.CircleData(x: 0 / 1500, y: 131 / 1100, size: ._240, color: .violet),
      HotKeywordPattern.CircleData(x: 742 / 1500, y: 504 / 1100, size: ._240, color: .green),
      HotKeywordPattern.CircleData(x: 500 / 1500, y: 256 / 1100, size: ._180, color: .blue),
      HotKeywordPattern.CircleData(x: 452 / 1500, y: 661 / 1100, size: ._140, color: .red),
      HotKeywordPattern.CircleData(x: 1050 / 1500, y: 100 / 1100, size: ._140, color: .orange),
      HotKeywordPattern.CircleData(x: 37 / 1500, y: 656 / 1100, size: ._120, color: .blue),
      HotKeywordPattern.CircleData(x: 289 / 1500, y: 564 / 1100, size: ._100, color: .green),
      HotKeywordPattern.CircleData(x: 333 / 1500, y: 835 / 1100, size: ._100, color: .orange),
      HotKeywordPattern.CircleData(x: 858 / 1500, y: 72 / 1100, size: ._100, color: .red),
      HotKeywordPattern.CircleData(x: 150 / 1500, y: 0 / 1100, size: ._80, color: .white),
    ]
  )

  static let pattern4 = HotKeywordPattern(
    circleDataList: [
      HotKeywordPattern.CircleData(x: 24 / 1500, y: 507 / 1100, size: ._240, color: .green),
      HotKeywordPattern.CircleData(x: 601 / 1500, y: 0 / 1100, size: ._240, color: .lime),
      HotKeywordPattern.CircleData(x: 86 / 1500, y: 88 / 1100, size: ._180, color: .orange),
      HotKeywordPattern.CircleData(x: 821 / 1500, y: 581 / 1100, size: ._180, color: .blue),
      HotKeywordPattern.CircleData(x: 1100 / 1500, y: 405 / 1100, size: ._140, color: .violet),
      HotKeywordPattern.CircleData(x: 619 / 1500, y: 556 / 1100, size: ._100, color: .red),
      HotKeywordPattern.CircleData(x: 1038 / 1500, y: 0 / 1100, size: ._100, color: .red),
      HotKeywordPattern.CircleData(x: 24 / 1500, y: 368 / 1100, size: ._80, color: .violet),
      HotKeywordPattern.CircleData(x: 443 / 1500, y: 302 / 1100, size: ._80, color: .white),
      HotKeywordPattern.CircleData(x: 500 / 1500, y: 836 / 1100, size: ._80, color: .blue),
    ]
  )
  
  static func generatePattern(without currentPattern: HotKeywordPattern? = nil) -> HotKeywordPattern {
    var newPatternList = patternList

    if let currentPattern {
      let currentPatternIndex = patternList.firstIndex(of: currentPattern)
      newPatternList.remove(at: currentPatternIndex ?? 0)
    }
    
    return newPatternList.randomElement() ?? pattern1
  }
}

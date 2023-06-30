//
//  swift
//  DesignSystem
//
//  Created by 리나 on 2023/06/26.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Foundation

public struct HotKeywordPattern: Equatable {
  public let circleDataList: [CircleData]
}

public struct CircleData: Hashable {
  public var x: Double
  public var y: Double
  public var size: BubbleSize
  public var color: BubbleColor
  
  public init(x: Double, y: Double, size: BubbleSize, color: BubbleColor) {
    self.x = x
    self.y = y
    self.size = size
    self.color = color
  }
}

public enum HotKeywordPatternSpace {
  static let patternList = [pattern1, pattern2, pattern3, pattern4]

  /*
   패턴은 피그마에 나와있는 superView를 1500 * 1000으로 확대하여(각 써클들도 확대) 그 위치를 기준으로 x,y 기준점 잡음
   그런데! 서클에 그림자가 있는 부분을 간과하고 확대해서 y 공간 아래 여유를 위해 100을 추가한 상태
   */
  static let pattern1 = HotKeywordPattern(
    circleDataList: [
      CircleData(x: 292 / 1500, y: 0 / 1100, size: ._240, color: .violet),
      CircleData(x: 760 / 1500, y: 507 / 1100, size: ._240, color: .lime),
      CircleData(x: 705 / 1500, y: 124 / 1100, size: ._180, color: .blue),
      CircleData(x: 330 / 1500, y: 600 / 1100, size: ._180, color: .blue),
      CircleData(x: 130 / 1500, y: 312 / 1100, size: ._140, color: .white),
      CircleData(x: 1100 / 1500, y: 422 / 1100, size: ._140, color: .orange),
      CircleData(x: 540 / 1500, y: 425 / 1100, size: ._120, color: .red),
      CircleData(x: 86 / 1500, y: 651 / 1100, size: ._120, color: .green),
      CircleData(x: 1186 / 1500, y: 133 / 1100, size: ._120, color: .green),
      CircleData(x: 940 / 1500, y: 45 / 1100, size: ._100, color: .white),
      CircleData(x: 61 / 1500, y: 214 / 1100, size: ._40, color: .violet),
      CircleData(x: 177 / 1500, y: 133 / 1100, size: ._30, color: .lime)
    ]
  )

  public static let pattern2 = HotKeywordPattern(
    circleDataList: [
      CircleData(x: 137 / 1500, y: 40 / 1100, size: ._240, color: .orange),
      CircleData(x: 580 / 1500, y: 391 / 1100, size: ._240, color: .lime),
      CircleData(x: 780 / 1500, y: 80 / 1100, size: ._180, color: .blue),
      CircleData(x: 410 / 1500, y: 670 / 1100, size: ._140, color: .green),
      CircleData(x: 277 / 1500, y: 500 / 1100, size: ._120, color: .red),
      CircleData(x: 1140 / 1500, y: 694 / 1100, size: ._120, color: .orange),
      CircleData(x: 550 / 1500, y: 196 / 1100, size: ._100, color: .white),
      CircleData(x: 137 / 1500, y: 771 / 1100, size: ._100, color: .violet),
      CircleData(x: 86 / 1500, y: 499 / 1100, size: ._80, color: .green),
      CircleData(x: 985 / 1500, y: 464 / 1100, size: ._80, color: .red),
      CircleData(x: 1280 / 1500, y: 350 / 1100, size: ._40, color: .orange)
    ]
  )

  static let pattern3 = HotKeywordPattern(
    circleDataList: [
      CircleData(x: 50 / 1500, y: 131 / 1100, size: ._240, color: .violet),
      CircleData(x: 760 / 1500, y: 504 / 1100, size: ._240, color: .lime),
      CircleData(x: 570 / 1500, y: 270 / 1100, size: ._180, color: .blue),
      CircleData(x: 320 / 1500, y: 0 / 1100, size: ._140, color: .white),
      CircleData(x: 502 / 1500, y: 661 / 1100, size: ._140, color: .red),
      CircleData(x: 1100 / 1500, y: 100 / 1100, size: ._140, color: .orange),
      CircleData(x: 87 / 1500, y: 656 / 1100, size: ._120, color: .blue),
      CircleData(x: 285 / 1500, y: 560 / 1100, size: ._100, color: .green),
      CircleData(x: 330 / 1500, y: 835 / 1100, size: ._100, color: .orange),
      CircleData(x: 940 / 1500, y: 80 / 1100, size: ._100, color: .red),
      CircleData(x: 690 / 1500, y: 75 / 1100, size: ._40, color: .green),
    ]
  )

  static let pattern4 = HotKeywordPattern(
    circleDataList: [
      CircleData(x: 74 / 1500, y: 507 / 1100, size: ._240, color: .green),
      CircleData(x: 651 / 1500, y: 0 / 1100, size: ._240, color: .lime),
      CircleData(x: 136 / 1500, y: 88 / 1100, size: ._180, color: .orange),
      CircleData(x: 851 / 1500, y: 581 / 1100, size: ._180, color: .blue),
      CircleData(x: 1130 / 1500, y: 385 / 1100, size: ._140, color: .violet),
      CircleData(x: 493 / 1500, y: 302 / 1100, size: ._140, color: .white),
      CircleData(x: 709 / 1500, y: 556 / 1100, size: ._100, color: .red),
      CircleData(x: 1030 / 1500, y: 0 / 1100, size: ._100, color: .red),
      CircleData(x: 80 / 1500, y: 330 / 1100, size: ._80, color: .violet),
      CircleData(x: 550 / 1500, y: 836 / 1100, size: ._80, color: .blue),
      CircleData(x: 1150 / 1500, y: 330 / 1100, size: ._30, color: .orange)
    ]
  )
  
  public static func generatePattern(without currentPattern: HotKeywordPattern? = nil) -> HotKeywordPattern {
    var newPatternList = patternList

    if let currentPattern {
      let currentPatternIndex = patternList.firstIndex(of: currentPattern)
      newPatternList.remove(at: currentPatternIndex ?? 0)
    }
    
    return newPatternList.randomElement() ?? pattern1
  }
}

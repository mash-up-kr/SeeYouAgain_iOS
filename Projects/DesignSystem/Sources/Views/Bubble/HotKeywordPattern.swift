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
      CircleData(x: 242 / 1500, y: 0 / 1100, size: ._240, color: .violet),
      CircleData(x: 693 / 1500, y: 507 / 1100, size: ._240, color: .lime),
      CircleData(x: 677 / 1500, y: 124 / 1100, size: ._180, color: .blue),
      CircleData(x: 290 / 1500, y: 578 / 1100, size: ._180, color: .blue),
      CircleData(x: 61 / 1500, y: 312 / 1100, size: ._140, color: .white),
      CircleData(x: 1104 / 1500, y: 422 / 1100, size: ._140, color: .orange),
      CircleData(x: 505 / 1500, y: 455 / 1100, size: ._120, color: .orange),
      CircleData(x: 36 / 1500, y: 651 / 1100, size: ._120, color: .green),
      CircleData(x: 1136 / 1500, y: 133 / 1100, size: ._120, color: .green),
      CircleData(x: 939 / 1500, y: 42 / 1100, size: ._100, color: .white),
      CircleData(x: 11 / 1500, y: 214 / 1100, size: ._40, color: .violet),
      CircleData(x: 127 / 1500, y: 133 / 1100, size: ._30, color: .lime)
    ]
  )

  static let pattern2 = HotKeywordPattern(
    circleDataList: [
      CircleData(x: 57 / 1500, y: 18 / 1100, size: ._240, color: .orange),
      CircleData(x: 571 / 1500, y: 391 / 1100, size: ._240, color: .lime),
      CircleData(x: 773 / 1500, y: 59 / 1100, size: ._180, color: .blue),
      CircleData(x: 356 / 1500, y: 661 / 1100, size: ._140, color: .green),
      CircleData(x: 207 / 1500, y: 497 / 1100, size: ._120, color: .red),
      CircleData(x: 1107 / 1500, y: 694 / 1100, size: ._120, color: .orange),
      CircleData(x: 530 / 1500, y: 196 / 1100, size: ._100, color: .white),
      CircleData(x: 57 / 1500, y: 771 / 1100, size: ._100, color: .violet),
      CircleData(x: 6 / 1500, y: 499 / 1100, size: ._80, color: .green),
      CircleData(x: 1049 / 1500, y: 464 / 1100, size: ._80, color: .red),
      CircleData(x: 1235 / 1500, y: 350 / 1100, size: ._40, color: .orange)
    ]
  )

  static let pattern3 = HotKeywordPattern(
    circleDataList: [
      CircleData(x: 0 / 1500, y: 131 / 1100, size: ._240, color: .violet),
      CircleData(x: 742 / 1500, y: 504 / 1100, size: ._240, color: .green),
      CircleData(x: 500 / 1500, y: 256 / 1100, size: ._180, color: .blue),
      CircleData(x: 452 / 1500, y: 661 / 1100, size: ._140, color: .red),
      CircleData(x: 1050 / 1500, y: 100 / 1100, size: ._140, color: .orange),
      CircleData(x: 37 / 1500, y: 656 / 1100, size: ._120, color: .blue),
      CircleData(x: 289 / 1500, y: 564 / 1100, size: ._100, color: .green),
      CircleData(x: 333 / 1500, y: 835 / 1100, size: ._100, color: .orange),
      CircleData(x: 858 / 1500, y: 72 / 1100, size: ._100, color: .red),
      CircleData(x: 150 / 1500, y: 0 / 1100, size: ._80, color: .white),
      CircleData(x: 664 / 1500, y: 75 / 1100, size: ._40, color: .green),
    ]
  )

  static let pattern4 = HotKeywordPattern(
    circleDataList: [
      CircleData(x: 24 / 1500, y: 507 / 1100, size: ._240, color: .green),
      CircleData(x: 601 / 1500, y: 0 / 1100, size: ._240, color: .lime),
      CircleData(x: 86 / 1500, y: 88 / 1100, size: ._180, color: .orange),
      CircleData(x: 821 / 1500, y: 581 / 1100, size: ._180, color: .blue),
      CircleData(x: 1100 / 1500, y: 405 / 1100, size: ._140, color: .violet),
      CircleData(x: 619 / 1500, y: 556 / 1100, size: ._100, color: .red),
      CircleData(x: 1038 / 1500, y: 0 / 1100, size: ._100, color: .red),
      CircleData(x: 24 / 1500, y: 368 / 1100, size: ._80, color: .violet),
      CircleData(x: 443 / 1500, y: 302 / 1100, size: ._80, color: .white),
      CircleData(x: 500 / 1500, y: 836 / 1100, size: ._80, color: .blue),
      CircleData(x: 1192 / 1500, y: 300 / 1100, size: ._30, color: .orange)
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

//
//  HotKeywordPoint.swift
//  DesignSystem
//
//  Created by 리나 on 2023/06/26.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Foundation

public struct HotKeywordPoint: Equatable, Hashable {
  public var x: Double
  public var y: Double
  public var bubbleColor: BubbleColor
  public var bubbleSize: BubbleSize
  public var keyword: String
  
  public init(keyword: String, circleData: CircleData) {
    self.x = circleData.x
    self.y = circleData.y
    self.bubbleColor = circleData.color
    self.bubbleSize = circleData.size
    self.keyword = keyword
  }
}

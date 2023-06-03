//
//  BubbleView.swift
//  DesignSystem
//
//  Created by GREEN on 2023/06/03.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Common
import SwiftUI

public struct BubbleView: View {
  let size: BubbleSize
  
  public var body: some View {
    Circle()
      .frame(width: 30)
  }
}

public enum BubbleSize: CGFloat {
  case _240 = 240
  case _180 = 180
  case _140 = 140
  case _120 = 120
  case _100 = 100
  case _80 = 80
}

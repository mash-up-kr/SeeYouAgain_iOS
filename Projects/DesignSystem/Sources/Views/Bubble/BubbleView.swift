//
//  BubbleView.swift
//  DesignSystem
//
//  Created by GREEN on 2023/06/03.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import SwiftUI

public struct BubbleView: View {
  let keyword: String
  let bubbleSize: BubbleSize
  let bubbleColor: BubbleColor
  var action: () -> Void = {}
  
  public init(
    keyword: String,
    bubbleSize: BubbleSize,
    bubbleColor: BubbleColor,
    action: @escaping () -> Void = {}
  ) {
    self.keyword = keyword
    self.bubbleSize = bubbleSize
    self.bubbleColor = bubbleColor
    self.action = action
  }
  
  public var body: some View {
    Button(
      action: action,
      label: {
        ZStack {
          Circle()
            .fill(bubbleColor.backgroundColor)
            .blur(radius: 18)
            .frame(width: bubbleSize.circleSize, height: bubbleSize.circleSize)
            .shadow(
              color: Color(red: 176/255, green: 128/255, blue: 230/255, opacity: 0.3),
              radius: 24,
              x: 0,
              y: 24
            )
            .shadow(
              color: Color(white: 1, opacity: 0.16),
              radius: 4,
              x: 2,
              y: 2
            )
          
          Text(keyword)
            .foregroundColor(bubbleColor.fontColor)
            .font(bubbleSize.font)
        }
      }
    )
  }
}

// MARK: - 원 및 키워드 텍스트 사이즈
public enum BubbleSize: CGFloat {
  case _240
  case _180
  case _140
  case _120
  case _100
  case _80
  
  var circleSize: CGFloat {
    switch self {
    case ._240:
      return 240
    case ._180:
      return 180
    case ._140:
      return 140
    case ._120:
      return 120
    case ._100:
      return 100
    case ._80:
      return 80
    }
  }
  
  var font: Font {
    switch self {
    case ._240:
      return .b24
    case ._180:
      return .b20
    case ._140:
      return .b18
    case ._120:
      return .b16
    case ._100:
      return .b14
    case ._80:
      return .b12
    }
  }
}

// MARK: - 버블 배경 및 키워드 폰트 컬러
public enum BubbleColor {
  case yellow
  case green
  case purple
  case blue
  case orange
  case lightGreen
  case white
  
  /// 버블 배경 컬러
  var backgroundColor: Color {
    switch self {
    case .yellow:
      return .yellow
      
    case .green:
      return .green
      
    case .purple:
      return .purple
      
    case .blue:
      return .blue
      
    case .orange:
      return .orange
      
    case .lightGreen:
      return .indigo
      
    case .white:
      return .white
    }
  }
  
  /// 버블 키워드 폰트 컬러
  var fontColor: Color {
    switch self {
    case .yellow:
      return .white
      
    case .green:
      return .white
      
    case .purple:
      return .white
      
    case .blue:
      return .white
      
    case .orange:
      return .white
      
    case .lightGreen:
      return .white
      
    case .white:
      return .black
    }
  }
}

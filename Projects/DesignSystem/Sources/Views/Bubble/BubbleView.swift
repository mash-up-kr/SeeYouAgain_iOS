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
            .fill(
              LinearGradient(
                gradient: Gradient(
                  colors: [
                    bubbleColor.backgroundFirstColor,
                    bubbleColor.backgroundSecondColor
                  ]
                ),
                startPoint: .top,
                endPoint: .bottom
              )
            )
            .frame(width: bubbleSize.circleSize, height: bubbleSize.circleSize)
            .optionalShadow(
              color: bubbleColor.dropShadowColor,
              radius: 24,
              x: 0,
              y: 24
            )
            .modifier(
              InnerShadow(
                color: bubbleColor.innerShadowColor,
                radius: 4,
                offset: CGSize(width: 2, height: 2)
              )
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
  case orange
  case green
  case violet
  case blue
  case red
  case lime
  case white
  
  /// Inner Shadow 컬러
  var innerShadowColor: Color {
    switch self {
    case .orange:
      return Color(red: 255 / 255, green: 255 / 255, blue: 255 / 255, opacity: 0.24)
    case .green:
      return Color(red: 255 / 255, green: 255 / 255, blue: 255 / 255, opacity: 0.24)
    case .violet:
      return Color(red: 255 / 255, green: 255 / 255, blue: 255 / 255, opacity: 0.24)
    case .blue:
      return Color(red: 255 / 255, green: 255 / 255, blue: 255 / 255, opacity: 0.24)
    case .red:
      return Color(red: 255 / 255, green: 255 / 255, blue: 255 / 255, opacity: 0.24)
    case .lime:
      return Color(red: 255 / 255, green: 255 / 255, blue: 255 / 255, opacity: 0.24)
    case .white:
      return Color(red: 255 / 255, green: 255 / 255, blue: 255 / 255, opacity: 0.24)
    }
  }
  
  /// Drop Shadow 컬러
  var dropShadowColor: Color? {
    switch self {
    case .orange:
      return Color(red: 244 / 255, green: 179 / 255, blue: 86 / 255, opacity: 0.3)
    case .green:
      return Color(red: 98 / 255, green: 201 / 255, blue: 140 / 255, opacity: 0.3)
    case .violet:
      return Color(red: 176 / 255, green: 128 / 255, blue: 230 / 255, opacity: 0.3)
    case .blue:
      return Color(red: 114 / 255, green: 196 / 255, blue: 244 / 255, opacity: 0.3)
    case .red:
      return Color(red: 244 / 255, green: 154 / 255, blue: 106 / 255, opacity: 0.3)
    case .lime:
      return Color(red: 176 / 255, green: 205 / 255, blue: 92 / 255, opacity: 0.3)
    case .white:
      return nil
    }
  }
  
  /// 버블 배경 첫번째 컬러
  var backgroundFirstColor: Color {
    switch self {
    case .orange:
      return Color(red: 253 / 255, green: 176 / 255, blue: 26 / 255, opacity: 0.8)
    case .green:
      return Color(red: 60 / 255, green: 202 / 255, blue: 116 / 255, opacity: 0.7)
    case .violet:
      return Color(red: 168 / 255, green: 105 / 255, blue: 234 / 255, opacity: 0.7)
    case .blue:
      return Color(red: 69 / 255, green: 178 / 255, blue: 255 / 255, opacity: 0.7)
    case .red:
      return Color(red: 252 / 255, green: 110 / 255, blue: 58 / 255, opacity: 0.7)
    case .lime:
      return Color(red: 177 / 255, green: 208 / 255, blue: 38 / 255, opacity: 0.7)
    case .white:
      return Color(red: 194 / 255, green: 194 / 255, blue: 194 / 255, opacity: 0.4)
    }
  }
  
  /// 버블 배경 두번째 컬러
  var backgroundSecondColor: Color {
    switch self {
    case .orange:
      return Color(red: 255 / 255, green: 161 / 255, blue: 30 / 255, opacity: 0.8)
    case .green:
      return Color(red: 46 / 255, green: 192 / 255, blue: 105 / 255, opacity: 0.7)
    case .violet:
      return Color(red: 158 / 255, green: 89 / 255, blue: 235 / 255, opacity: 0.7)
    case .blue:
      return Color(red: 69 / 255, green: 187 / 255, blue: 255 / 255, opacity: 0.7)
    case .red:
      return Color(red: 255 / 255, green: 129 / 255, blue: 57 / 255, opacity: 0.7)
    case .lime:
      return Color(red: 158 / 255, green: 199 / 255, blue: 38 / 255, opacity: 0.7)
    case .white:
      return Color(red: 194 / 255, green: 194 / 255, blue: 194 / 255, opacity: 0.4)
    }
  }
  
  /// 버블 키워드 폰트 컬러
  var fontColor: Color {
    switch self {
    case .orange:
      return .white
    case .green:
      return .white
    case .violet:
      return .white
    case .blue:
      return .white
    case .red:
      return .white
    case .lime:
      return .white
    case .white:
      return Color(red: 69 / 255, green: 72 / 255, blue: 73 / 255)
    }
  }
}

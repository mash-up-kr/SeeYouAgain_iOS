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
  let geometryHeight: CGFloat
  let pointX: CGFloat
  let action: () -> Void
  
  @Binding private var offset: CGFloat
  @State private var isAnimated: Bool = false
  
  // 써클의 중앙이 보일때 애니메이션을 시작해야하는데, 스크롤 할 때 offset이 크게 잡히는 경향이 있어서 여유 공간을 뺀 너비를 사용함
  private let spaceWidth: CGFloat = {
    let screenWidth = UIScreen.main.bounds.width
    return screenWidth * 2 / 3
  }()
  
  public init(
    hotKeywordPoint: HotKeywordPoint,
    geometryHeight: CGFloat,
    pointX: CGFloat,
    offset: Binding<CGFloat>,
    action: @escaping () -> Void = {}
  ) {
    self.keyword = hotKeywordPoint.keyword
    self.bubbleSize = hotKeywordPoint.bubbleSize
    self.bubbleColor = hotKeywordPoint.bubbleColor
    self.geometryHeight = geometryHeight
    self.pointX = pointX
    self._offset = offset
    self.action = action
  }
  
  public var body: some View {
    Button(
      action: action,
      label: {
        ZStack {
          blurView
          
          colorView
          
          Text(keyword)
            .font(bubbleSize.font)
            .multilineTextAlignment(.center)
            .foregroundColor(bubbleColor.fontColor)
        }
        .scaleEffect(isAnimated ? 1 : 0.001) // ignoring singular matrix에러로 인해 0 대신 0.001로 설정
        .animation(.spring(), value: isAnimated)
        .onAppear {
          isAnimated = offset > pointX
        }
        .onChange(of: offset) { currentOffset in
          if isAnimated == false {
            isAnimated = currentOffset > (pointX - spaceWidth)
          } else if currentOffset < (pointX - spaceWidth * 3 / 2) {
            isAnimated = false
          }
        }
        .frame(
          width: bubbleSize.sizeRatio * geometryHeight,
          height: bubbleSize.sizeRatio * geometryHeight
        )
      }
    )
  }
  
  private var blurView: some View {
    ZStack { }
      .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
      .blurEffect()
      .background(bubbleColor.linearGradient)
      .cornerRadius(ceil(bubbleSize.sizeRatio * geometryHeight / 2))
      .opacity(0.9)
      .shadow(color: bubbleColor.shadowColor, radius: 12, x: 0, y: 24)
  }
  
  private var colorView: some View {
    ZStack { }
      .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
      .background(bubbleColor.linearGradient)
      .cornerRadius(ceil(bubbleSize.sizeRatio * geometryHeight / 2))
      .shadow(color: bubbleColor.shadowColor, radius: 12, x: 0, y: 24)
      .opacity(0.6)
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
  case _40 // 단순 데코용
  case _30 // 단순 데코용
  
  public var sizeRatio: CGFloat {
    switch self {
    case ._240:
      return 240 / 550
    case ._180:
      return 180 / 550
    case ._140:
      return 140 / 550
    case ._120:
      return 120 / 550
    case ._100:
      return 100 / 550
    case ._80:
      return 80 / 550
    case ._40:
      return 40 / 550
    case ._30:
      return 30 / 550
    }
  }
  
  public var font: Font {
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
    default:
      return .b12 // 최소 사이즈로 임의 설정
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
  
  /// 버블 그레디언트 색상 값
  private var gradientList: [Gradient.Stop] {
    switch self {
    case .orange:
      return [
        Gradient.Stop(color: Color(red: 0.99, green: 0.69, blue: 0.1).opacity(0.8), location: 0.00),
        Gradient.Stop(color: Color(red: 1, green: 0.63, blue: 0.12).opacity(0.8), location: 1.00),
      ]
    case .green:
      return [
        Gradient.Stop(color: Color(red: 0.24, green: 0.79, blue: 0.45).opacity(0.7), location: 0.00),
        Gradient.Stop(color: Color(red: 0.18, green: 0.75, blue: 0.41).opacity(0.7), location: 1.00),
      ]
    case .violet:
      return [
        Gradient.Stop(color: Color(red: 0.2, green: 0.62, blue: 1).opacity(0.7), location: 0.00),
        Gradient.Stop(color: Color(red: 0.66, green: 0.41, blue: 0.92).opacity(0.7), location: 0.00),
        Gradient.Stop(color: Color(red: 0.62, green: 0.35, blue: 0.92).opacity(0.7), location: 1.00),
      ]
    case .blue:
      return [
        Gradient.Stop(color: Color(red: 0.27, green: 0.7, blue: 1).opacity(0.7), location: 0.00),
        Gradient.Stop(color: Color(red: 0.27, green: 0.73, blue: 1).opacity(0.7), location: 1.00),
      ]
    case .red:
      return [
        Gradient.Stop(color: Color(red: 0.99, green: 0.43, blue: 0.23).opacity(0.7), location: 0.00),
        Gradient.Stop(color: Color(red: 1, green: 0.5, blue: 0.22).opacity(0.7), location: 1.00),
      ]
    case .lime:
      return [
        Gradient.Stop(color: Color(red: 0.69, green: 0.82, blue: 0.15).opacity(0.7), location: 0.00),
        Gradient.Stop(color: Color(red: 0.62, green: 0.78, blue: 0.15).opacity(0.7), location: 0.96),
      ]
    case .white:
      return [
        Gradient.Stop(color: .white.opacity(0.4), location: 0.00),
        Gradient.Stop(color: .white.opacity(0), location: 1.00),
      ]
    }
  }
  
  /// 버블 그레디언트 위치 값
  var linearGradient: LinearGradient {
    switch self {
    case .white:
      return LinearGradient(
        stops: gradientList,
        startPoint: UnitPoint(x: 0.19, y: 0.13),
        endPoint: UnitPoint(x: 0.5, y: 1)
      )
    default:
      return LinearGradient(
        stops: gradientList,
        startPoint: UnitPoint(x: 0.5, y: 0),
        endPoint: UnitPoint(x: 0.5, y: 1)
      )
    }
  }
  
  /// 버블 그림자 컬러
  var shadowColor: Color {
    switch self {
    case .orange:
      return Color(red: 0.96, green: 0.6, blue: 0.42).opacity(0.3)
    case .green:
      return Color(red: 0.38, green: 0.79, blue: 0.55).opacity(0.3)
    case .violet:
      return Color(red: 0.68, green: 0.49, blue: 0.93).opacity(0.3)
    case .blue:
      return Color(red: 0.45, green: 0.77, blue: 0.96).opacity(0.3)
    case .red:
      return Color(red: 0.96, green: 0.6, blue: 0.42).opacity(0.3)
    case .lime:
      return Color(red: 0.69, green: 0.8, blue: 0.36).opacity(0.3)
    case .white:
      return Color(red: 1.0, green: 1.0, blue: 1.0).opacity(0.3)
    }
  }
  
  /// 버블 키워드 폰트 컬러
  var fontColor: Color {
    switch self {
    case .white:
      return Color(red: 69 / 255, green: 72 / 255, blue: 73 / 255)
    default:
      return .white
    }
  }
}

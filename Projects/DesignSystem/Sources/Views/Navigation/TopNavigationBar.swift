//
//  TopNavigationBar.swift
//  DesignSystem
//
//  Created by GREEN on 2023/04/05.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import SwiftUI

public struct TopNavigationBar: View {
  public let title: String?
  public let leftIcon: Image?
  public let leftText: String?
  public var leftIconButtonAction: () -> Void = {}
  public let rightIcon: Image?
  public let rightText: String?
  public var rightIconButtonAction: () -> Void = {}
  
  public init(
    title: String? = nil,
    leftIcon: Image? = nil,
    leftText: String? = nil,
    leftIconButtonAction: @escaping () -> Void = {},
    rightIcon: Image? = nil,
    rightText: String? = nil,
    rightIconButtonAction: @escaping () -> Void = {}
  ) {
    self.title = title
    self.leftIcon = leftIcon
    self.leftText = leftText
    self.leftIconButtonAction = leftIconButtonAction
    self.rightIcon = rightIcon
    self.rightText = rightText
    self.rightIconButtonAction = rightIconButtonAction
  }
  
  public var body: some View {
    HStack {
      BarButton(
        type: .left,
        icon: leftIcon,
        text: leftText,
        action: leftIconButtonAction
      )

      Spacer()
      
      if let title = title {
        HStack {
          Spacer()
          
          Text(title)
            .font(.r16)
            .foregroundColor(DesignSystem.Colors.grey100)
          
          Spacer()
        }
      }
      
      Spacer()

      BarButton(
        type: .right,
        icon: rightIcon,
        text: rightText,
        action: rightIconButtonAction
      )
    }
    .frame(height: 48, alignment: .center)
    .background(Color.white)
  }
}

fileprivate struct BarButton: View {
  private var type: `Type` = .left
  private var icon: Image?
  private var text: String?
  private var action: () -> Void = {}
  
  fileprivate enum `Type` {
    case left
    case right
  }
  
  fileprivate init(
    type: `Type` = .left,
    icon: Image? = nil,
    text: String? = nil,
    action: @escaping () -> Void = {}
  ) {
    self.type = type
    self.icon = icon
    self.text = text
    self.action = action
  }
  
  fileprivate var body: some View {
    Button(action: action) {
      HStack {
        if let icon = icon {
          icon
            .frame(width: 26, height: 26, alignment: .center)
            .padding(11)
        }
        
        if let text = text {
          Text(text)
            .font(.r16)
            .foregroundColor(DesignSystem.Colors.grey100)
            .padding(type == .left ? .leading : .trailing, 16)
        }
      }
      .frame(width: 48, height: 48)
    }
  }
}

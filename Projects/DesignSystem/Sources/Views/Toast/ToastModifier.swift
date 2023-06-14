//
//  ToastModifier.swift
//  DesignSystem
//
//  Created by GREEN on 2023/06/12.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import SwiftUI

private struct CustomToastPaddingModifier: ViewModifier {
  private var verticalPadding: CGFloat
  private var horizontalPadding: CGFloat
  private var width: CGFloat
  private var height: CGFloat
  private var backgroundColor: Color
  private var backgroundRadius: CGFloat
  
  fileprivate init(
    verticalPadding: CGFloat = 16,
    horizontalPadding: CGFloat = 24,
    width: CGFloat = 327,
    height: CGFloat = 50,
    backgroundColor: Color,
    backgroundRadius: CGFloat = 10
  ) {
    self.verticalPadding = verticalPadding
    self.horizontalPadding = horizontalPadding
    self.width = width
    self.height = height
    self.backgroundColor = backgroundColor
    self.backgroundRadius = backgroundRadius
  }
  
  fileprivate func body(content: Content) -> some View {
    content
      .padding(.vertical, verticalPadding)
      .padding(.horizontal, horizontalPadding)
      .frame(width: width, height: height)
      .background(backgroundColor.cornerRadius(backgroundRadius))
  }
}

extension View {
  func customToastPadding(backgroundColor: Color) -> some View {
    self.modifier(CustomToastPaddingModifier(backgroundColor: backgroundColor))
  }
  
  public func toast(
    text: String?,
    toastType: ToastType,
    toastOffset: CGFloat = 0
  ) -> some View {
    return self.overlay(
      ToastView(
        text: text,
        toastType: toastType
      )
      .offset(y: toastOffset)
      .animation(.spring(), value: text != nil),
      alignment: .bottom
    )
  }
}

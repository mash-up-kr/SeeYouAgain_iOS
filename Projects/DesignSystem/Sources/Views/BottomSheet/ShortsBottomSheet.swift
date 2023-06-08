//
//  BottomSheet.swift
//  Main
//
//  Created by 김영균 on 2023/06/06.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import SwiftUI

public extension View {
  func shortsBottomSheet<Content: View>(
    isShowing: Binding<Bool>,
    content: @escaping () -> Content
  ) -> some View {
    modifier(
      ShortsBottomSheet(
        isShowing: isShowing,
        content: content
      )
    )
  }
}

private struct ShortsBottomSheet<T: View>: ViewModifier {
  @Binding private var isShowing: Bool
  private var height: CGFloat
  private var content: () -> T
  
  fileprivate init(
    isShowing: Binding<Bool>,
    height: CGFloat = 384,
    content: @escaping () -> T
  ) {
    self._isShowing = isShowing
    self.height = height
    self.content = content
  }
  
  fileprivate func body(content: Content) -> some View {
    ZStack {
      content
      ZStack(alignment: .bottom) {
        if isShowing {
          // dimmed view
          DesignSystem.Colors.grey100
            .opacity(0.4)
            .ignoresSafeArea()
            .onTapGesture {
              isShowing = false
            }
            .transition(.opacity)
          
          // bottom sheet
          self.content()
            .padding(.bottom, 0)
            .frame(height: height)
            .transition(.move(edge: .bottom))
        }
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
    }
    .ignoresSafeArea()
    .animation(.easeInOut, value: isShowing)
  }
  
  private struct RoundCorners: Shape {
    var radius: CGFloat = 5
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
      let path = UIBezierPath(
        roundedRect: rect,
        byRoundingCorners: corners,
        cornerRadii: CGSize(width: radius, height: radius)
      )
      return Path(path.cgPath)
    }
  }
}

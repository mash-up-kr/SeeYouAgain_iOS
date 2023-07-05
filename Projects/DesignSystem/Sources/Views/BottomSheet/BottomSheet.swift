//
//  BottomSheet.swift
//  DesignSystem
//
//  Created by 김영균 on 2023/06/08.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import SwiftUI

public struct BottomSheet<
  BackgroundColor: View,
  HeaderArea: View,
  Content: View,
  BottomArea: View
>: View {
  private var backgroundColor: BackgroundColor
  @Binding private var isPresented: Bool
  private var headerArea: HeaderArea
  private var content: Content
  private var bottomArea: BottomArea
  
  private let keyWindow = UIApplication.shared.connectedScenes
    .compactMap { $0 as? UIWindowScene }
    .flatMap { $0.windows }
    .first { $0.isKeyWindow }
  
  public init(
    backgroundColor: BackgroundColor,
    isPresented: Binding<Bool>,
    @ViewBuilder headerArea: () -> HeaderArea,
    @ViewBuilder content: () -> Content,
    @ViewBuilder bottomArea: () -> BottomArea
  ) {
    self.backgroundColor = backgroundColor
    self._isPresented = isPresented
    self.headerArea = headerArea()
    self.content = content()
    self.bottomArea = bottomArea()
  }
  
  public var body: some View {
    VStack(spacing: 0) {
      headerArea
        .padding(.top, 32)
      
      content
        .padding(.horizontal, 24)
        .padding(.top, 32)
      
      bottomArea
        .padding(.top, 24)
      
      Spacer()
        .frame(height: keyWindow?.safeAreaInsets.bottom)
        .padding(.top, 8)
    }
    .background(backgroundColor)
    .clipShape(RoundCorners())
  }
}

public extension View {
  func bottomSheet<
    BackgroundColor: View,
    HeaderArea: View,
    Content: View,
    BottomArea: View
  >(
    backgroundColor: BackgroundColor = Color.white,
    isPresented: Binding<Bool>,
    @ViewBuilder headerArea: () -> HeaderArea,
    @ViewBuilder content: () -> Content,
    @ViewBuilder bottomArea: () -> BottomArea
  ) -> some View {
    ZStack {
      self
      
      ZStack(alignment: .bottom) {
        if isPresented.wrappedValue {
          DesignSystem.Colors.grey100.opacity(0.4)
            .ignoresSafeArea(.container, edges: .all)
            .zIndex(1)
            .onTapGesture {
              isPresented.wrappedValue = false
            }
            .transition(.opacity)
          
          BottomSheet(
            backgroundColor: backgroundColor,
            isPresented: isPresented,
            headerArea: headerArea,
            content: content,
            bottomArea: bottomArea
          )
          .zIndex(2)
          .transition(.move(edge: .bottom))
        }
      }
      .ignoresSafeArea()
    }
    .animation(.easeInOut, value: isPresented.wrappedValue)
  }
}

private struct RoundCorners: Shape {
  var radius: CGFloat = 20
  var corners: UIRectCorner = [.topLeft, .topRight]
  
  func path(in rect: CGRect) -> Path {
    let path = UIBezierPath(
      roundedRect: rect,
      byRoundingCorners: corners,
      cornerRadii: CGSize(width: radius, height: radius)
    )
    return Path(path.cgPath)
  }
}

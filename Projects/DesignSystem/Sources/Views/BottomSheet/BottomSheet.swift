//
//  BottomSheet.swift
//  DesignSystem
//
//  Created by 김영균 on 2023/06/08.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import SwiftUI

public struct BottomSheet<Content: View, BottomArea: View>: View {
  public var title: String
  @Binding public var isPresented: Bool
  public var content: Content
  public var bottomArea: BottomArea
  
  public let keyWindow = UIApplication.shared.connectedScenes
    .compactMap { $0 as? UIWindowScene }
    .flatMap { $0.windows }
    .first { $0.isKeyWindow }
  
  public init(
    title: String,
    isPresented: Binding<Bool>,
    @ViewBuilder content: () -> Content,
    @ViewBuilder bottomArea: () -> BottomArea
  ) {
    self.title = title
    self._isPresented = isPresented
    self.content = content()
    self.bottomArea = bottomArea()
  }
  
  public var body: some View {
    VStack(spacing: 0) {
      HeaderView(title: title)
        .padding(.top, 32)
      
      content
        .padding(.horizontal, 24)
        .padding(.top, 32)
      
      bottomArea
        .padding(.top, 32)
      
      Spacer()
        .frame(height: keyWindow?.safeAreaInsets.bottom)
        .padding(.top, 8)
    }
    .background(Color.white.opacity(0.8).blurEffect())
    .clipShape(RoundCorners(radius: 20, corners: [.topLeft, .topRight]))    
  }
}

private struct RoundCorners: Shape {
  var radius: CGFloat = 20
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

private struct HeaderView: View {
  var title: String
  
  var body: some View {
    HStack {
      Text(title)
        .font(.b18)
        .foregroundColor(DesignSystem.Colors.grey100)
      Spacer()
    }
    .padding(.horizontal, 24)
  }
}

extension View {
  public func bottomSheet<Content: View, BottomArea: View>(
    title: String,
    isPresented: Binding<Bool>,
    @ViewBuilder content: () -> Content,
    @ViewBuilder bottomArea: () -> BottomArea
  ) -> some View {
    ZStack(alignment: .bottom) {
      self
      
      if isPresented.wrappedValue {
        DesignSystem.Colors.grey100.opacity(0.4)
          .ignoresSafeArea(.container, edges: .all)
          .zIndex(1)
          .onTapGesture {
            isPresented.wrappedValue = false
          }
          .transition(.opacity)
        
        BottomSheet(
          title: title,
          isPresented: isPresented,
          content: content,
          bottomArea: bottomArea
        )
        .zIndex(2)
        .transition(.move(edge: .bottom))
      }
    }
    .edgesIgnoringSafeArea(.bottom)
  }
}

//
//  View+extensions.swift
//  Common
//
//  Created by GREEN on 2023/04/05.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import SwiftUI

extension View {
  public func apply<Content: View>(content: (Self) -> Content) -> AnyView {
    return content(self).eraseToAnyView()
  }
  
  public func eraseToAnyView() -> AnyView {
    return AnyView(self)
  }
  
  public func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
    clipShape(RoundCorners(radius: radius, corners: corners))
  }
}

fileprivate struct RoundCorners: Shape {
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

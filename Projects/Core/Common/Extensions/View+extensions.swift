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
}

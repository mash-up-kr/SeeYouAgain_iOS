//
//  ShortsToggleStyle.swift
//  DesignSystem
//
//  Created by 안상희 on 2023/06/18.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import SwiftUI

public struct ShortsToggleStyle: ToggleStyle {
  public init() {}
  
  public func makeBody(configuration: Configuration) -> some View {
    Button {
      configuration.isOn.toggle()
    } label: {
      configuration.isOn ? DesignSystem.Icons.iconCheckCircle : DesignSystem.Icons.iconDefaultCheckCircle
    }
    .onTapGesture {
      withAnimation {
        configuration.$isOn.wrappedValue.toggle()
      }
    }
  }
}

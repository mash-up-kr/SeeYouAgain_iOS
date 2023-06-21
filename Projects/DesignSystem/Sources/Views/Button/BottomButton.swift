//
//  BottomButton.swift
//  DesignSystem
//
//  Created by GREEN on 2023/06/05.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import SwiftUI

public struct BottomButton: View {
  let title: String
  var disabled: Bool
  var action: () -> Void
  @State private var isSelected: Bool = false
  private var backgroundColor: Color {
    if disabled {
      return DesignSystem.Colors.grey40
    } else if isSelected {
      return DesignSystem.Colors.blue300
    } else {
      return DesignSystem.Colors.blue200
    }
  }

  public init(
    title: String,
    disabled: Bool = false,
    action: @escaping () -> Void = {}
  ) {
    self.title = title
    self.disabled = disabled
    self.action = action
  }
  
  public var body: some View {
    HStack {
      Spacer()
        .frame(width: 20)
      
      HStack {
        Spacer()
        
        Text(title)
          .font(.r16)
          .foregroundColor(DesignSystem.Colors.white)
        
        Spacer()
      }
      .frame(height: 52)
      .background(backgroundColor)
      .cornerRadius(12)
      .gesture(
        DragGesture(minimumDistance: 0)
          .onChanged { _ in
            isSelected = true
          }
          .onEnded { _ in
            isSelected = false
            action()
          }
      )
      .disabled(disabled)
      
      Spacer()
        .frame(width: 20)
    }
  }
}

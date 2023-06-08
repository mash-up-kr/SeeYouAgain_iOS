//
//  CategoryBadgeButton.swift
//  Main
//
//  Created by 김영균 on 2023/06/06.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import SwiftUI

public struct CategoryBadgeButton: View {
  private let name: String
  private let icon: Image
  private var action: () -> Void
  
  public init(
    name: String,
    icon: Image,
    action: @escaping () -> Void
  ) {
    self.name = name
    self.icon = icon
    self.action = action
  }
  
  public var body: some View {
    Button(action: action) {
      HStack(spacing: 8) {
        icon
        Text("\(name)")
          .font(.r14)
          .foregroundColor(DesignSystem.Colors.grey90)
      }
      .padding(.horizontal, 10)
      .padding(.vertical, 5)
      .background(DesignSystem.Colors.white.opacity(0.7).blurEffect())
      .cornerRadius(24)
      .overlay {
        RoundedRectangle(cornerRadius: 24)
          .strokeBorder(DesignSystem.Colors.white, lineWidth: 1)
      }
    }
  }
}

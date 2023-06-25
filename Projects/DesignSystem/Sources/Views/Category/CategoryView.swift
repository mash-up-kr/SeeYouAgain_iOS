//
//  CategoryView.swift
//  DesignSystem
//
//  Created by 안상희 on 2023/06/25.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import SwiftUI

public struct CategoryView: View {
  private var category: String
  private var color: Color
  
  public init(
    category: String,
    color: Color
  ) {
    self.category = category
    self.color = color
  }
  
  public var body: some View {
    VStack(spacing: 0) {
      Text(category)
        .font(.r12)
        .foregroundColor(DesignSystem.Colors.grey20)
        .padding(.horizontal, 6)
        .padding(.vertical, 2)
        .background(color)
        .cornerRadius(26)
    }
  }
}

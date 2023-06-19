//
//  CategoryBadgeButton.swift
//  Main
//
//  Created by 김영균 on 2023/06/06.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import DesignSystem
import SwiftUI

struct CategoryBadge: View {
  private let name: String
  
  init(name: String) {
    self.name = name
  }
  
  var body: some View {
    Text(name)
      .font(.b14)
      .foregroundColor(DesignSystem.Colors.grey70)
      .padding(.horizontal, 16)
      .padding(.vertical, 8)
      .background(DesignSystem.Colors.white.opacity(0.5))
      .cornerRadius(24)
  }
}

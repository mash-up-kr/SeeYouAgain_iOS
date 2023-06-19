//
//  CategoryDetailButton.swift
//  DesignSystem
//
//  Created by 김영균 on 2023/06/07.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import DesignSystem
import SwiftUI

struct CategoryDetailButton: View {
  private var action: () -> Void
  
  init(action: @escaping () -> Void) {
    self.action = action
  }
  
  var body: some View {
    Button(action: action) {
      DesignSystem.Icons.badgeDetail
    }
  }
}

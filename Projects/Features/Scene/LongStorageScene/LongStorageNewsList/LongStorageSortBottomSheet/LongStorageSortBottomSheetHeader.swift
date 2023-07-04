//
//  LongStorageSortBottomSheetHeader.swift
//  Splash
//
//  Created by 김영균 on 2023/07/04.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import DesignSystem
import SwiftUI

struct LongStorageSortBottomSheetHeader: View {
  var body: some View {
    HStack {
      Text("정렬")
        .font(.b18)
        .foregroundColor(DesignSystem.Colors.grey100)
      Spacer()
    }
    .padding(.horizontal, 24)
  }
}

//
//  DateFilterBottomSheetHeader.swift
//  LongStorageNewsList
//
//  Created by 안상희 on 2023/07/06.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import ComposableArchitecture
import DesignSystem
import SwiftUI

struct DateFilterBottomSheetHeader: View {
  var body: some View {
    HStack {
      Text("날짜를 선택해주세요")
        .font(.b18)
        .foregroundColor(DesignSystem.Colors.grey100)
      
      Spacer()
    }
    .padding(.horizontal, 24)
  }
}

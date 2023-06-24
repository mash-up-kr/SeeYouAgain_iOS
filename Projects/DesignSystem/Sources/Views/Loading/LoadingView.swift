//
//  LoadingView.swift
//  DesignSystem
//
//  Created by GREEN on 2023/06/23.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import SwiftUI

public struct LoadingView: View {
  public var body: some View {
    VStack(spacing: 5) {
      ProgressView()
        .scaleEffect(2.0)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(DesignSystem.Colors.grey100.opacity(0.4))
  }
}

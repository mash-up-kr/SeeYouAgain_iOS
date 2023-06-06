//
//  SeeYouAgainTabBarView.swift
//  TabBar
//
//  Created by 안상희 on 2023/06/04.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import DesignSystem
import SwiftUI

public struct ShortsTabBarView: View {
  public let tabs: [TabBarItem]
  @Binding var selection: TabBarItem
  private let selectionWidth: [CGFloat] = [90, 105, 87]
  
  public var body: some View {
    GeometryReader { geometry in
      VStack {
        Spacer()
        HStack(spacing: 8) {
          ForEach(tabs, id: \.self) { tab in
            singleTabView(tab: tab)
          }
          .frame(height: 42)
        }
        .frame(width: geometry.size.width, height: 82)
        .background(
          Color.white.ignoresSafeArea(edges: .bottom)
        )
        .cornerRadius(24)
      }
    }
    .padding(
      EdgeInsets(top: 0, leading: 24, bottom: 0, trailing: 24)
    )
  }
}

extension ShortsTabBarView {
  private func singleTabView(tab: TabBarItem) -> some View {
    HStack(spacing: 0) {
      (selection == tab ? tab.selectedIcon : tab.icon)
        .renderingMode(.template)
        .frame(width: 26, height: 26)
      
      if selection == tab {
        Spacer()
          .frame(width: 8)
        
        Text(tab.description)
          .font(DesignSystemFontFamily.Pretendard.bold._14)
          .fixedSize()
      }
    }
    .foregroundColor(selection == tab ? tab.color : Color.gray)
    .padding(
      EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16)
    )
    .scaleEffect(1)
    .frame(width: selection == tab ? selectionWidth[tab.rawValue] : 79)
    .background(
      selection == tab ? tab.color.opacity(0.2) : Color.clear
    )
    .cornerRadius(20)
    .onTapGesture {
      withAnimation(.linear(duration: 0.2)) {
        selection = tab
      }
    }
  }
}

//
//  ShortsTabBarView.swift
//  TabBar
//
//  Created by 안상희 on 2023/06/04.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import DesignSystem
import SwiftUI

struct ShortsTabBarView: View {
  public let tabs: [TabBarItem]
  @Binding var selection: TabBarItem
  private let selectionWidth: [CGFloat] = [98, 113, 95]
  
  var body: some View {
    GeometryReader { geometry in
      VStack {
        Spacer()
        
        HStack(spacing: 8) {
          ForEach(tabs, id: \.self) { tab in
            singleTabView(tab: tab)
          }
          .frame(height: 50)
        }
        .frame(width: geometry.size.width, height: 82)
        .background(
          DesignSystem.Colors.coolgrey100
        )
        .cornerRadius(24)
        .overlay(
          RoundedRectangle(cornerRadius: 24)
            .stroke(
              LinearGradient(
                gradient: Gradient(colors: [Color.clear, Color.white]),
                startPoint: .leading,
                endPoint: .trailing
              )
            )
        )
      }
    }
    .padding(.horizontal, 24)
  }
}

extension ShortsTabBarView {
  private func singleTabView(tab: TabBarItem) -> some View {
    HStack(spacing: 0) {
      (selection == tab ? tab.selectedIcon : tab.defaultIcon)
        .frame(width: 26, height: 26)
      
      if selection == tab {
        Spacer()
          .frame(width: 8)
        
        Text(tab.description)
          .font(.b14)
          .foregroundColor(tab.textColor)
          .fixedSize()
      }
    }
    .padding(.horizontal, 20)
    .padding(.vertical, 12)
    .scaleEffect(1)
    .frame(width: selection == tab ? selectionWidth[tab.rawValue] : 79)
    .background(
      selection == tab ? tab.backgroundColor : Color.clear
    )
    .cornerRadius(32)
    .onTapGesture {
      withAnimation(.linear(duration: 0.2)) {
        selection = tab
      }
    }
  }
}

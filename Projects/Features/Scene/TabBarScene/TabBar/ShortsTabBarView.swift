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
  
  private let keyWindow = UIApplication.shared.connectedScenes
  .compactMap { $0 as? UIWindowScene }
  .flatMap { $0.windows }
  .first { $0.isKeyWindow }
  
  var body: some View {
    GeometryReader { geometry in
      VStack(spacing: 0) {
        Spacer()
        
        HStack(spacing: 8) {
          ForEach(tabs, id: \.self) { tab in
            singleTabView(tab: tab)
          }
          .frame(height: 50)
        }
        .frame(width: geometry.size.width, height: 82)
        .background(DesignSystem.Colors.white)
        .cornerRadius(40, corners: [.topLeft, .topRight])
        
        DesignSystem.Colors.white
          .frame(height: keyWindow?.safeAreaInsets.bottom ?? 0)
      }
      .ignoresSafeArea(edges: [.bottom])
    }
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

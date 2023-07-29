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
  
  private let keyWindow = UIApplication.shared.connectedScenes
    .compactMap { $0 as? UIWindowScene }
    .flatMap { $0.windows }
    .first { $0.isKeyWindow }
  
  var body: some View {
    GeometryReader { geometry in
      VStack(spacing: 0) {
        Spacer()
        
        HStack(spacing: 0) {
          Spacer().frame(width: 32)
          singleTabView(tab: TabBarItem.hotKeyword)
          
          Spacer().frame(width: 8)
          singleTabView(tab: TabBarItem.house)
          
          Spacer().frame(width: 8)
          singleTabView(tab: TabBarItem.myPage)
          
          Spacer().frame(width: 32)
        }
        .padding(.vertical, 16)
        .background(DesignSystem.Colors.white)
        .cornerRadius(40, corners: [.topLeft, .topRight])
        
        DesignSystem.Colors.white.frame(height: keyWindow?.safeAreaInsets.bottom ?? 0)
      }
      .ignoresSafeArea(edges: [.bottom])
    }
  }
}

extension ShortsTabBarView {
  private func singleTabView(tab: TabBarItem) -> some View {
    HStack(spacing: 0) {
      if selection == tab {
        tab.selectedIcon
          .frame(width: 26, height: 26)
        
        Spacer()
          .frame(width: 8)
        
        Text(tab.description)
          .font(.b14)
          .foregroundColor(tab.textColor)
          .fixedSize()
        
      } else {
        Spacer()
        
        tab.defaultIcon
          .frame(width: 26, height: 26)
        
        Spacer()
      }
    }
    .padding(.horizontal, 20)
    .padding(.vertical, 12)
    .background(selection == tab ? tab.backgroundColor : Color.clear)
    .cornerRadius(32)
    .onTapGesture {
      withAnimation(.linear(duration: 0.2)) {
        selection = tab
      }
    }
  }
}

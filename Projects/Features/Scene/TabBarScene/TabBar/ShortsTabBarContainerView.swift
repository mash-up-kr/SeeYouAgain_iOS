//
//  ShortsTabBarContainerView.swift
//  TabBar
//
//  Created by 안상희 on 2023/06/04.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import SwiftUI

struct ShortsTabBarContainerView<Content: View>: View {
  @Binding var selection: TabBarItem
  @Binding var isHidden: Bool
  private let content: Content
  
  @State private var tabs: [TabBarItem] = []
  
  init(
    selection: Binding<TabBarItem>,
    isHidden: Binding<Bool>,
    @ViewBuilder content: () -> Content
  ) {
    self._selection = selection
    self._isHidden = isHidden
    self.content = content()
  }
  
  public var body: some View {
    ZStack {
      content
        .zIndex(isHidden ? 1 : 0)
      
      ShortsTabBarView(
        tabs: tabs,
        selection: $selection
      )
    }
    .onPreferenceChange(TabBarItemsPreferenceKey.self) { value in
      self.tabs = value
    }
  }
}

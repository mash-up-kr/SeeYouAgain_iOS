//
//  ShortsTabBarContainerView.swift
//  TabBar
//
//  Created by 안상희 on 2023/06/04.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import SwiftUI

public struct ShortsTabBarContainerView<Content: View>: View {
  @Binding var selection: TabBarItem
  private let content: Content
  
  @State private var tabs: [TabBarItem] = []
  
  init(selection: Binding<TabBarItem>, @ViewBuilder content: () -> Content) {
    self._selection = selection
    self.content = content()
  }
  
  public var body: some View {
    ZStack(alignment: .bottom) {
      content
        .ignoresSafeArea()
      
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

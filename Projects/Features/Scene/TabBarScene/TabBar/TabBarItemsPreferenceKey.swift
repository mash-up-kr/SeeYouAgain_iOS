//
//  TabBarItemsPreferenceKey.swift
//  TabBar
//
//  Created by 안상희 on 2023/06/04.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import SwiftUI

struct TabBarItemsPreferenceKey: PreferenceKey {
  static var defaultValue: [TabBarItem] = []
  
  static func reduce(value: inout [TabBarItem], nextValue: () -> [TabBarItem]) {
    value += nextValue()
  }
}

struct TabBarItemViewModifier: ViewModifier {
  let tab: TabBarItem
  @Binding var selection: TabBarItem
  
  func body(content: Content) -> some View {
    content
      .opacity(selection == tab ? 1.0 : 0.0)
      .preference(key: TabBarItemsPreferenceKey.self, value: [tab])
  }
}

extension View {
  func tabBarItem(tab: TabBarItem, selection: Binding<TabBarItem>) -> some View {
    modifier(TabBarItemViewModifier(tab: tab, selection: selection))
  }
}

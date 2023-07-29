//
//  WatchAppView.swift
//  shorts-watch Watch App
//
//  Created by 리나 on 2023/07/29.
//

import ComposableArchitecture
import SwiftUI

public struct WatchAppView: View {
  private let store: Store<WatchAppState, WatchAppAction>
  
  public init(store: Store<WatchAppState, WatchAppAction>) {
    self.store = store
  }
  
  public var body: some View {
    WithViewStore(store) { viewStore in
      TabView {
        WatchTodayShortsTabView(
          store: store.scope(
            state: \.watchTodayShortsTab,
            action: WatchAppAction.watchTodayShortsTab)
        )
        WatchHotKeywordTabView(
          store: store.scope(
            state: \.watchHotKeywordTab,
            action: WatchAppAction.watchHotKeywordTab)
        )
      }
    }
  }
}

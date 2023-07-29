//
//  ShortsWatchApp.swift
//  shorts Watch App
//
//  Created by 리나 on 2023/07/29.
//

import ComposableArchitecture
import ServicesWatchOS
import SwiftUI

@main
struct ShortsWatchApp: App {
  var body: some Scene {
    WindowGroup {
      WatchAppView(
        store:
            .init(
              initialState: .init(),
              reducer: watchAppReducer,
              environment: .init(
                mainQueue: .main,
                hotKeywordService: .live,
                newsCardService: .live
              )
            )
      )
    }
  }
}

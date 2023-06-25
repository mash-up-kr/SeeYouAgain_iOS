//
//  NewsCardCoordinatorView.swift
//  CoordinatorKit
//
//  Created by GREEN on 2023/04/28.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import ComposableArchitecture
import NewsList
import SwiftUI
import TCACoordinators
import Web

public struct NewsCardCoordinatorView: View {
  private let store: Store<NewsCardCoordinatorState, NewsCardCoordinatorAction>
  
  public init(store: Store<NewsCardCoordinatorState, NewsCardCoordinatorAction>) {
    self.store = store
  }
  
  public var body: some View {
    TCARouter(store) { screen in
      SwitchStore(screen) {
        CaseLet(
          state: /NewsCardScreenState.newsList,
          action: NewsCardScreenAction.newsList,
          then: NewsListView.init
        )
        CaseLet(
          state: /NewsCardScreenState.web,
          action: NewsCardScreenAction.web,
          then: WebView.init
        )
      }
    }
    .navigationBarHidden(true)
  }
}

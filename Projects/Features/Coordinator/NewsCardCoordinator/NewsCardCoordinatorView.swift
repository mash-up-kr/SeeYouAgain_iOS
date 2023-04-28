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

public struct NewsCardCoordinatorView: View {
  private let store: Store<NewsCardCoordinatorState, NewsCardCoordinatorAction>
  
  public init(store: Store<NewsCardCoordinatorState, NewsCardCoordinatorAction>) {
    self.store = store
  }
  
  public var body: some View {
    VStack(spacing: 0) {
      TCARouter(store) { screen in
        SwitchStore(screen) {
          CaseLet(
            state: /NewsCardCoordinatorState.newsList,
            action: NewsCardCoordinatorAction.newsList,
            then: NewsListView.init
          )
        }
      }
    }
    .edgesIgnoringSafeArea(.all)
  }
}

//
//  HotKeywordCoordinatorView.swift
//  Coordinator
//
//  Created by GREEN on 2023/04/28.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import ComposableArchitecture
import HotKeyword
import HotKeywordNewsList
import SwiftUI
import TCACoordinators

public struct HotKeywordCoordinatorView: View {
  private let store: Store<HotKeywordCoordinatorState, HotKeywordCoordinatorAction>
  
  public init(store: Store<HotKeywordCoordinatorState, HotKeywordCoordinatorAction>) {
    self.store = store
  }
  
  public var body: some View {
    VStack(spacing: 0) {
      TCARouter(store) { screen in
        SwitchStore(screen) {
          CaseLet(
            state: /HotKeywordScreenState.hotKeyword,
            action: HotKeywordScreenAction.hotKeyword,
            then: HotKeywordView.init
          )
          CaseLet(
            state: /HotKeywordScreenState.hotKeywordNewsList,
            action: HotKeywordScreenAction.hotKeywordNewsList,
            then: HotKeywordNewsListView.init
          )
        }
      }
    }
    .edgesIgnoringSafeArea(.all)
  }
}

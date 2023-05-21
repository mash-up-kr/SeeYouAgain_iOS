//
//  TabBarCoordinatorView.swift
//  Coordinator
//
//  Created by 안상희 on 2023/05/21.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Combine
import ComposableArchitecture
import HotKeywordCoordinator
import SwiftUI
import TCACoordinators

public struct TabBarCoordinatorView: View {
  private let store: Store<TabBarCoordinatorState, TabBarCoordinatorAction>
  
  public init(store: Store<TabBarCoordinatorState, TabBarCoordinatorAction>) {
    self.store = store
  }
  
  public var body: some View {
    TCARouter(store) { screen in
      SwitchStore(screen) {
        CaseLet(
          state: /TabBarScreenState.hotKeyword,
          action: TabBarScreenAction.hotKeyword,
          then: HotKeywordCoordinatorView.init
        )
      }
    }
  }
}

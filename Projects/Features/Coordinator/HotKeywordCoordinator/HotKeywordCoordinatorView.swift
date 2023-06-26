//
//  HotKeywordCoordinatorView.swift
//  Coordinator
//
//  Created by GREEN on 2023/04/28.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import ComposableArchitecture
import HotKeyword
import LongStorageCoordinator
import SwiftUI
import TCACoordinators

public struct HotKeywordCoordinatorView: View {
  private let store: Store<HotKeywordCoordinatorState, HotKeywordCoordinatorAction>
  
  public init(store: Store<HotKeywordCoordinatorState, HotKeywordCoordinatorAction>) {
    self.store = store
  }
  
  public var body: some View {
    TCARouter(store) { screen in
      SwitchStore(screen) {
        CaseLet(
          state: /HotKeywordScreenState.hotKeyword,
          action: HotKeywordScreenAction.hotKeyword,
          then: HotKeywordView.init
        )
        CaseLet(
          state: /HotKeywordScreenState.longStorage,
          action: HotKeywordScreenAction.longStorage,
          then: LongStorageCoordinatorView.init
        )
      }
    }
  }
}

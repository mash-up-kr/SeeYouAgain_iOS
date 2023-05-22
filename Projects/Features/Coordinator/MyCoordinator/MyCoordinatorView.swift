//
//  MyCoordinatorView.swift
//  MyCoordinator
//
//  Created by 안상희 on 2023/05/22.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import ComposableArchitecture
import LongStorageCoordinator
import ShortStorageCoordinator
import SwiftUI
import TCACoordinators

public struct MyCoordinatorView: View {
  private let store: Store<MyCoordinatorState, MyCoordinatorAction>
  
  public init(store: Store<MyCoordinatorState, MyCoordinatorAction>) {
    self.store = store
  }
  
  public var body: some View {
    TCARouter(store) { screen in
      SwitchStore(screen) {
        CaseLet(
          state: /MyScreenState.shortStorage,
          action: MyScreenAction.shortStorage,
          then: ShortStorageCoordinatorView.init
        )
        CaseLet(
          state: /MyScreenState.longStorage,
          action: MyScreenAction.longStorage,
          then: LongStorageCoordinatorView.init
        )
      }
    }
  }
}

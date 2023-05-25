//
//  ShortStorageCoordinatorView.swift
//  Coordinator
//
//  Created by GREEN on 2023/04/28.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import ComposableArchitecture
import ShortStorageNewsList
import SwiftUI
import TCACoordinators

public struct ShortStorageCoordinatorView: View {
  private let store: Store<ShortStorageCoordinatorState, ShortStorageCoordinatorAction>
  
  public init(store: Store<ShortStorageCoordinatorState, ShortStorageCoordinatorAction>) {
    self.store = store
  }
  
  public var body: some View {
    VStack(spacing: 0) {
      TCARouter(store) { screen in
        SwitchStore(screen) {
          CaseLet(
            state: /ShortStorageScreenState.shortStorageNewsList,
            action: ShortStorageScreenAction.shortStorageNewsList,
            then: ShortStorageNewsListView.init
          )
        }
      }
    }
    .edgesIgnoringSafeArea(.all)
  }
}

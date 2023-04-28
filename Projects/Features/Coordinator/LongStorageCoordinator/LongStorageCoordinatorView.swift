//
//  LongStorageCoordinatorView.swift
//  CoordinatorKit
//
//  Created by GREEN on 2023/04/28.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import ComposableArchitecture
import LongStorageNewsList
import SwiftUI
import TCACoordinators

public struct LongStorageCoordinatorView: View {
  private let store: Store<LongStorageCoordinatorState, LongStorageCoordinatorAction>
  
  public init(store: Store<LongStorageCoordinatorState, LongStorageCoordinatorAction>) {
    self.store = store
  }
  
  public var body: some View {
    VStack(spacing: 0) {
      TCARouter(store) { screen in
        SwitchStore(screen) {
          CaseLet(
            state: /LongStorageCoordinatorState.longStorageNewsList,
            action: LongStorageCoordinatorAction.longStorageNewsList,
            then: LongStorageNewsListView.init
          )
        }
      }
    }
    .edgesIgnoringSafeArea(.all)
  }
}

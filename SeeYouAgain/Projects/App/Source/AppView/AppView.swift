//
//  AppView.swift
//  App
//
//  Created by GREEN on 2023/04/05.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import ComposableArchitecture
import MainCoordinator
import SwiftUI

struct AppView: View {
  private let store: Store<AppState, AppAction>
  
  public init(store: Store<AppState, AppAction>) {
    self.store = store
  }
  
  var body: some View {
    WithViewStore(store) { viewStore in
      MainCoordinatorView.init(
        store: .init(
          initialState: .init(),
          reducer: mainCoordinatorReducer,
          environment: .init(userService: .unimplemented)
        )
      )
      .onAppear { viewStore.send(.onAppear) }
    }
  }
}

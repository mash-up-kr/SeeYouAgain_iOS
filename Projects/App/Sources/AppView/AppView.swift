//
//  AppView.swift
//  App
//
//  Created by GREEN on 2023/04/05.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import AppCoordinator
import ComposableArchitecture
import SwiftUI

struct AppView: View {
  private let store: Store<AppState, AppAction>
  
  public init(store: Store<AppState, AppAction>) {
    self.store = store
  }
  
  var body: some View {
    WithViewStore(store) { viewStore in
      AppCoordinatorView.init(
        store: .init(
          initialState: .init(),
          reducer: appCoordinatorReducer,
          environment: .init(userDefaultsService: .live)
        )
      )
      .onAppear { viewStore.send(.onAppear) }
    }
  }
}

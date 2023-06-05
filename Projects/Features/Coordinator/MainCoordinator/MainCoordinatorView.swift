//
//  MainCoordinatorView.swift
//  MainCoordinator
//
//  Created by 안상희 on 2023/05/21.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import ComposableArchitecture
import Main
import SwiftUI
import TCACoordinators

public struct MainCoordinatorView: View {
  private let store: Store<MainCoordinatorState, MainCoordinatorAction>
  
  public init(store: Store<MainCoordinatorState, MainCoordinatorAction>) {
    self.store = store
  }
  
  public var body: some View {
    VStack(spacing: 0) {
      TCARouter(store) { screen in
        SwitchStore(screen) {
          CaseLet(
            state: /MainScreenState.main,
            action: MainScreenAction.main,
            then: MainView.init
          )
        }
      }
    }
    .edgesIgnoringSafeArea(.all)
  }
}

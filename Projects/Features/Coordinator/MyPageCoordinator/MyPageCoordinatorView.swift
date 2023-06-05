//
//  MyPageCoordinatorView.swift
//  MyPageCoordinator
//
//  Created by 안상희 on 2023/05/22.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import ComposableArchitecture
import LongStorageCoordinator
import ShortStorageCoordinator
import SwiftUI
import TCACoordinators

public struct MyPageCoordinatorView: View {
  private let store: Store<MyPageCoordinatorState, MyPageCoordinatorAction>
  
  public init(store: Store<MyPageCoordinatorState, MyPageCoordinatorAction>) {
    self.store = store
  }
  
  public var body: some View {
    VStack(spacing: 0) {
      TCARouter(store) { screen in
        SwitchStore(screen) {
          CaseLet(
            state: /MyPageScreenState.shortStorage,
            action: MyPageScreenAction.shortStorage,
            then: ShortStorageCoordinatorView.init
          )
          CaseLet(
            state: /MyPageScreenState.longStorage,
            action: MyPageScreenAction.longStorage,
            then: LongStorageCoordinatorView.init
          )
        }
      }
    }
    .edgesIgnoringSafeArea(.all)
  }
}

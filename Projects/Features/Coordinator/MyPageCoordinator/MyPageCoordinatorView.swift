//
//  MyPageCoordinatorView.swift
//  MyPageCoordinator
//
//  Created by 안상희 on 2023/05/22.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import ComposableArchitecture
import DesignSystem
import LongStorageCoordinator
import MyPage
import SettingCoordinator
import ShortStorageCoordinator
import SwiftUI
import TCACoordinators

public struct MyPageCoordinatorView: View {
  private let store: Store<MyPageCoordinatorState, MyPageCoordinatorAction>
  
  public init(store: Store<MyPageCoordinatorState, MyPageCoordinatorAction>) {
    self.store = store
  }
  
  public var body: some View {
    TCARouter(store) { screen in
      SwitchStore(screen) {
        CaseLet(
          state: /MyPageScreenState.myPage,
          action: MyPageScreenAction.myPage,
          then: MyPageView.init
        )
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
        CaseLet(
          state: /MyPageScreenState.setting,
          action: MyPageScreenAction.setting,
          then: SettingCoordinatorView.init
        )
      }
    }
  }
}

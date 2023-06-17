//
//  ShortStorageNewsListView.swift
//  Scene
//
//  Created by GREEN on 2023/04/28.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import ComposableArchitecture
import DesignSystem
import SwiftUI

public struct ShortStorageNewsListView: View {
  private let store: Store<ShortStorageNewsListState, ShortStorageNewsListAction>
  
  public init(store: Store<ShortStorageNewsListState, ShortStorageNewsListAction>) {
    self.store = store
  }
  
  public var body: some View {
    WithViewStore(store) { viewStore in
      VStack(spacing: 0) {
        TopNavigationBar(
          leftIcon: DesignSystem.Icons.iconNavigationLeft,
          leftIconButtonAction: {
            viewStore.send(.backButtonTapped)
          }
        )
        
        Text("단기저장 카드에 대한 뉴스 기사 리스트 화면")
        
        Spacer()
      }
    }
    .navigationBarHidden(true)
  }
}

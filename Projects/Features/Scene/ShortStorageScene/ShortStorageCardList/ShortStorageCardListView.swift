//
//  ShortStorageCardListView.swift
//  Scene
//
//  Created by GREEN on 2023/04/28.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import ComposableArchitecture
import SwiftUI
import Views

public struct ShortStorageCardListView: View {
  private let store: Store<ShortStorageCardListState, ShortStorageCardListAction>
  
  public init(store: Store<ShortStorageCardListState, ShortStorageCardListAction>) {
    self.store = store
  }
  
  public var body: some View {
    WithViewStore(store) { viewStore in
      Text("단기저장 뉴스 카드 리스트 화면")
    }
    .navigationBarHidden(true)
  }
}

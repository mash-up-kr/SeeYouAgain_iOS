//
//  LongStorageNewsListView.swift
//  Scene
//
//  Created by GREEN on 2023/04/28.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import ComposableArchitecture
import SwiftUI
import Views

public struct LongStorageNewsListView: View {
  private let store: Store<LongStorageNewsListState, LongStorageNewsListAction>
  
  public init(store: Store<LongStorageNewsListState, LongStorageNewsListAction>) {
    self.store = store
  }
  
  public var body: some View {
    WithViewStore(store) { viewStore in
      Text("장기저장 뉴스 기사 리스트 화면")
    }
    .navigationBarHidden(true)
  }
}

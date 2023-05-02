//
//  HotKeywordNewsListView.swift
//  Scene
//
//  Created by GREEN on 2023/04/28.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

public struct HotKeywordNewsListView: View {
  private let store: Store<HotKeywordNewsListState, HotKeywordNewsListAction>
  
  public init(store: Store<HotKeywordNewsListState, HotKeywordNewsListAction>) {
    self.store = store
  }
  
  public var body: some View {
    WithViewStore(store) { viewStore in
      Text("실시간 핫 키워드에 대한 뉴스 리스트 화면")
    }
    .navigationBarHidden(true)
  }
}

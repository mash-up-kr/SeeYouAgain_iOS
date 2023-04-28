//
//  NewsListView.swift
//  Scene
//
//  Created by GREEN on 2023/04/28.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import ComposableArchitecture
import SwiftUI
import Views

public struct NewsListView: View {
  private let store: Store<NewsListState, NewsListAction>
  
  public init(store: Store<NewsListState, NewsListAction>) {
    self.store = store
  }
  
  public var body: some View {
    WithViewStore(store) { viewStore in
      Text("뉴스 리스트 화면")
    }
    .navigationBarHidden(true)
  }
}

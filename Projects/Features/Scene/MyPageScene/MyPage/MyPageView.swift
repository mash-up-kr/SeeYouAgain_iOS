//
//  MyPageView.swift
//  MyPage
//
//  Created by 안상희 on 2023/05/22.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import ComposableArchitecture
import DesignSystem
import SwiftUI

public struct MyPageView: View {
  private let store: Store<MyPageState, MyPageAction>
  
  public init(store: Store<MyPageState, MyPageAction>) {
    self.store = store
  }
  
  public var body: some View {
    WithViewStore(store) { viewStore in
      Text("마이뷰")
    }
    .navigationBarHidden(true)
  }
}

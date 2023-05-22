//
//  MyView.swift
//  My
//
//  Created by 안상희 on 2023/05/22.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import ComposableArchitecture
import DesignSystem
import SwiftUI

public struct MyView: View {
  private let store: Store<MyState, MyAction>
  
  public init(store: Store<MyState, MyAction>) {
    self.store = store
  }
  
  public var body: some View {
    WithViewStore(store) { viewStore in
      Text("마이뷰")
    }
    .navigationBarHidden(true)
  }
}

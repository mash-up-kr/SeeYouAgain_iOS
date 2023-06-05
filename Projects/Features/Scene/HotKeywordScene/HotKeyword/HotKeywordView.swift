//
//  HotKeywordView.swift
//  Scene
//
//  Created by GREEN on 2023/04/28.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

public struct HotKeywordView: View {
  private let store: Store<HotKeywordState, HotKeywordAction>
  
  public init(store: Store<HotKeywordState, HotKeywordAction>) {
    self.store = store
  }
  
  public var body: some View {
    WithViewStore(store) { viewStore in
      HStack {
        VStack {
          Text("실시간 핫 키워드 화면")
          Spacer()
        }
        Spacer()
      }
      .background(Color.red)
    }
    .navigationBarHidden(true)
  }
}

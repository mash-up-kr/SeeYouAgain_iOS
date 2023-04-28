//
//  SetCategoryView.swift
//  SetCategory
//
//  Created by GREEN on 2023/04/28.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import ComposableArchitecture
import SwiftUI
import Views

public struct SetCategoryView: View {
  private let store: Store<SetCategoryState, SetCategoryAction>
  
  public init(store: Store<SetCategoryState, SetCategoryAction>) {
    self.store = store
  }
  
  public var body: some View {
    WithViewStore(store) { viewStore in
      Text("카테고리 설정 화면")
    }
    .navigationBarHidden(true)
  }
}

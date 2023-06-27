//
//  MyInfoView.swift
//  MyPage
//
//  Created by 안상희 on 2023/06/15.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import ComposableArchitecture
import DesignSystem
import SwiftUI

struct MyInfoView: View {
  private let store: Store<MyInfoState, MyInfoAction>
  
  init(store: Store<MyInfoState, MyInfoAction>) {
    self.store = store
  }
  
  var body: some View {
    WithViewStore(store) { viewStore in
      VStack(spacing: 32) {
        HStack(spacing: 0) {
          VStack(alignment: .leading, spacing: 4) {
            Text("\(viewStore.state.user.nickname)님")
              .font(.b24)
              .foregroundColor(DesignSystem.Colors.grey100)
            
            Text("\(viewStore.state.user.joinPeriod)일째 숏스와 세상을 읽는 중")
              .font(.r14)
              .foregroundColor(DesignSystem.Colors.grey70)
          }
          
          Spacer()
        }
        
        MyShortsView(
          store: store.scope(
            state: \.shorts,
            action: MyInfoAction.shortsAction
          )
        )
      }
      .background(Color.clear)
    }
  }
}

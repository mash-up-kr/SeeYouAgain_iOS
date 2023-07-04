//
//  LongStorageSortBottomSheetContent.swift
//  Splash
//
//  Created by 김영균 on 2023/07/04.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Common
import ComposableArchitecture
import DesignSystem
import SwiftUI

struct LongStorageSortBottomSheetContent: View {
  private let store: Store<SortBottomSheetState, SortBottomSheetAction>
  
  init(store: Store<SortBottomSheetState, SortBottomSheetAction>) {
    self.store = store
  }
  
  var body: some View {
    WithViewStore(store, observe: \.sortType) { viewStore in
      VStack {
        Button {
          viewStore.send(._setSortType(.latest))
        } label: {
          HStack {
            Text("최신순")
              .font(.r16)
              .foregroundColor(DesignSystem.Colors.grey100)
            
            Spacer()
            
            DesignSystem.Icons.iconCheck
              .frame(width: 20, height: 20)
              .opacity(viewStore.state == .latest ? 1 : 0)
          }
          .padding(.top, 8)
        }

        Button {
          viewStore.send(._setSortType(.outdated))
        } label: {
          HStack {
            Text("오래된 순")
              .font(.r16)
              .foregroundColor(DesignSystem.Colors.grey100)
            
            Spacer()
            
            DesignSystem.Icons.iconCheck
              .frame(width: 20, height: 20)
              .opacity(viewStore.state == .outdated ? 1 : 0)
          }
          .padding(.top, 24)
          .padding(.bottom, 8)
        }
      }
    }
  }
}

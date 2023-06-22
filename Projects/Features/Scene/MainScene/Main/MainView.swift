//
//  MainView.swift
//  Main
//
//  Created by 김영균 on 2023/06/21.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import ComposableArchitecture
import DesignSystem
import SwiftUI

public struct MainView: View {
  private let store: Store<MainState, MainAction>
  
  public init(store: Store<MainState, MainAction>) {
    self.store = store
  }
  
  public var body: some View {
    WithViewStore(store) { viewStore in
      VStack {
        DesignSystem.Images.mainTitle
          .resizable()
          .scaledToFit()
        
        Spacer()
          .frame(height: 16)
        
        CategoriesView(store: store.scope(state: \.categories))
          .frame(height: 32)
        
        Spacer()
          .frame(height: 40)
        
        IfLetStore(
          store.scope(
            state: \.newsCardScrollState,
            action: MainAction.newsCardScroll
          )
        ) { store in
          NewsCardScrollView(store: store)
            .frame(height: viewStore.newsCardSize.height)
        }
        
        Spacer()
          .frame(height: 24)
        
        SaveTextView()
        
        Spacer()
      }
      .onAppear {
        viewStore.send(._setScreenSize(UIScreen.main.bounds.size))
        viewStore.send(._viewWillAppear)
      }
    }
    .shortsBackgroundView()
    .navigationBarHidden(true)
  }
}

private struct SaveTextView: View {
  fileprivate var body: some View {
    VStack(spacing: 8) {
      DesignSystem.Icons.caretDown
      Text("아래로 내려서 저장하기")
        .font(.b14)
        .foregroundColor(DesignSystem.Colors.grey70)
    }
  }
}

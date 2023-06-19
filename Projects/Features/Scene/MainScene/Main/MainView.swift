//
//  MainView.swift
//  Main
//
//  Created by GREEN on 2023/04/05.
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
        
        Spacer().frame(height: 16)
        
        CategoriesView(store: store.scope(state: \.categories))
          .frame(height: 32)
        
        Spacer().frame(height: 40)
        
        IfLetStore(
          store.scope(
            state: \.letterScrollState,
            action: MainAction.letterScrollAction
          )
        ) { store in
          LetterScrollView(store: store)
            .frame(height: 200)
        }
        Spacer()
      }
      .onAppear {
        viewStore.send(._viewWillAppear)
      }
    }
    .shortsBackgroundView()
    .navigationBarHidden(true)
  }
}

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
            .frame(height: viewStore.newsCardLayout.size.height)
        }
        
        Spacer()
          .frame(height: 24)
        
        IfLetStore(
          store.scope(
            state: \.saveGuideState,
            action: MainAction.saveGuide
          )
        ) { store in
          SaveGuideView(store: store)          
        }
        
        Spacer()
      }
      .onAppear {
        viewStore.send(._setNewsCardSize(UIScreen.main.bounds.size))
        viewStore.send(._viewWillAppear)
      }
    }
    .shortsBackgroundView()
    .navigationBarHidden(true)
  }
}

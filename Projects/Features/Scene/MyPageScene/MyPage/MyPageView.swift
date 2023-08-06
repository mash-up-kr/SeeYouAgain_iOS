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
      VStack(spacing: 0) {
        TopNavigationBar(
          rightIcon: DesignSystem.Icons.iconSetting,
          rightIconButtonAction: {
            viewStore.send(.settingButtonTapped(viewStore.state.nickname))
          }
        )
        
        ZStack(alignment: .topTrailing) {
          DesignSystem.Images.imageEarth
            .frame(width: 124, height: 121)
            .padding(.trailing, 24)
          
          MyInfoView(
            store: store.scope(
              state: \.info,
              action: MyPageAction.info
            )
          )
          .padding(.horizontal, 24)
          
          Spacer()
        }
        .padding(.top, 32)
        
        Spacer()
          .frame(height: 39)
        
        MyAchievementsView(
          store: store.scope(
            state: \.myAchievements,
            action: MyPageAction.myAchievementsAction
          )
        )        
      }
      .onAppear {
        viewStore.send(._viewWillAppear)
      }
    }
    .navigationBarHidden(true)
    .edgesIgnoringSafeArea(.bottom)
    .myPageBackgroundView()
  }
}

fileprivate struct MyPageBackgroundView: View {
  fileprivate init() { }
  
  fileprivate var body: some View {
    ZStack {
      Color.white
        .opacity(1)
        .edgesIgnoringSafeArea(.all)
      
      GeometryReader { geometry in
        Circle()
          .fill(
            Color(red: 45/255, green: 205/255, blue: 255/255, opacity: 0.5)
          )
          .frame(width: 188, height: 188)
          .blur(radius: 96)
          .offset(x: -43, y: 178)
      }
    }
  }
}

extension View {
  fileprivate func myPageBackgroundView() -> some View {
    ZStack {
      MyPageBackgroundView()
      self
    }
  }
}

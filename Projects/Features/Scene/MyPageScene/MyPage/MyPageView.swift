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
      ZStack {
        ScrollView {
          VStack(spacing: 0) {
            VStack(spacing: 0) {
              TopNavigationBar(
                rightIcon: DesignSystem.Icons.iconSetting,
                rightIconButtonAction: {
                  viewStore.send(.settingButtonTapped)
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
                .frame(height: 40)
            }
            .myPageBackgroundView()
            
            VStack(spacing: 32) {
              StatisticsView(
                store: store.scope(
                  state: \.statistics,
                  action: MyPageAction.statisticsAction
                )
              )
              
              MyAchievementsView(
                store: store.scope(
                  state: \.myAchievements,
                  action: MyPageAction.myAchievementsAction
                )
              )
              
              Spacer()
                .frame(height: 82 + 46)
            }
            .padding(.horizontal, 24)
            .myStatisticsBackgroundView()
          }
          .onAppear {
            viewStore.send(._onAppear)
          }
        }
        .navigationBarHidden(true)
        .edgesIgnoringSafeArea(.bottom)
      }
    }
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

fileprivate struct MyStatisticsBackgroundView: View {
  fileprivate init() {}
  
  fileprivate var body: some View {
    ZStack {
      DesignSystem.Colors.coolgrey100
        .opacity(1)
        .edgesIgnoringSafeArea(.all)
      
      GeometryReader { geometry in
        Circle()
          .fill(
            Color(red: 159/255, green: 114/255, blue: 255/255, opacity: 0.5)
          )
          .frame(width: 153, height: 153)
          .blur(radius: 96)
          .offset(x: 256, y: 23)
        
        Circle()
          .fill(
            Color(red: 114/255, green: 187/255, blue: 255/255, opacity: 0.3)
          )
          .frame(width: 189, height: 189)
          .blur(radius: 96)
          .offset(x: -44, y: 299)
        
        Circle()
          .fill(
            Color(red: 130/255, green: 255/255, blue: 247/255, opacity: 0.4)
          )
          .frame(width: 113, height: 113)
          .blur(radius: 96)
          .offset(x: 307, y: 510)
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
  
  fileprivate func myStatisticsBackgroundView() -> some View {
    ZStack {
      MyStatisticsBackgroundView()
      self
    }
  }
}

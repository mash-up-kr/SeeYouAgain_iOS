//
//  AppVersionView.swift
//  Splash
//
//  Created by 김영균 on 2023/08/05.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import ComposableArchitecture
import DesignSystem
import SwiftUI

public struct AppVersionView: View {
  private let store: Store<AppVersionState, AppVersionAction>
  
  public init(store: Store<AppVersionState, AppVersionAction>) {
    self.store = store
  }
  
  public var body: some View {
    WithViewStore(store) { viewStore in
      VStack {
        TopNavigationBar(
          title: "앱 버전",
          leftIcon: DesignSystem.Icons.iconNavigationLeft,
          leftIconButtonAction: {
            viewStore.send(.backButtonTapped)
          }
        )
        
        HStack {
          VStack(alignment: .leading, spacing: 4) {
            Text("앱 버전 v\(viewStore.state.appVersion)")
              .font(.b16)
              .foregroundColor(DesignSystem.Colors.grey100)
            
            Text(viewStore.state.appVersionDescription)
              .font(.r14)
              .foregroundColor(DesignSystem.Colors.grey80)
          }
          
          Spacer()
        }
        .padding(.top, 16)
        .padding(.horizontal, 24)
        
        Spacer()
          .frame(height: 24)
        
        if !viewStore.state.isLatestAppVersion {
          UpdateButtonView(store: store.stateless)
        }
        
        Spacer()
      }
      .onAppear { viewStore.send(._onAppear) }
    }
    .navigationBarHidden(true)
  }
}

// MARK: - 업데이트 버튼
private struct UpdateButtonView: View {
  private let store: Store<Void, AppVersionAction>
  
  fileprivate init(store: Store<Void, AppVersionAction>) {
    self.store = store
  }
  
  fileprivate var body: some View {
    WithViewStore(store) { viewStore in
      Button(
        action: {
          viewStore.send(.updateButtonTapped)
        },
        label: {
          HStack {
            Spacer()
            
            Text("최신버전으로 업데이트")
              .font(Font.custom("Apple SD Gothic Neo", size: 16))
              .foregroundColor(DesignSystem.Colors.grey70)
            
            Spacer()
          }
        }
      )
      .frame(height: 52)
      .overlay(
        RoundedRectangle(cornerRadius: 12)
          .inset(by: 0.5)
          .stroke(
            DesignSystem.Colors.grey30,
            lineWidth: 1
          )
      )
      .padding(.horizontal, 24)
    }
  }
}

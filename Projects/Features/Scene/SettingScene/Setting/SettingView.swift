//
//  SettingView.swift
//  Scene
//
//  Created by GREEN on 2023/04/28.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import ComposableArchitecture
import DesignSystem
import SwiftUI

public struct SettingView: View {
  private let store: Store<SettingState, SettingAction>
  
  public init(store: Store<SettingState, SettingAction>) {
    self.store = store
  }
  
  public var body: some View {
    WithViewStore(store) { viewStore in
      VStack(spacing: 0) {
        TopNavigationBar(
          title: "설정",
          leftIcon: DesignSystem.Icons.iconNavigationLeft,
          leftIconButtonAction: {
            viewStore.send(.backButtonTapped)
          }
        )
        
        AppVersionView(store: store)
        
        Spacer()
          .frame(height: 24)
        
        if !viewStore.state.isLatestAppVersion {
          UpdateButtonView(store: store)
        }
        
        Spacer()
      }
      .onAppear {
        viewStore.send(._onAppear)
      }
    }
    .navigationBarHidden(true)
  }
}

// MARK: - 앱 버전
private struct AppVersionView: View {
  private let store: Store<SettingState, SettingAction>
  
  fileprivate init(store: Store<SettingState, SettingAction>) {
    self.store = store
  }
  
  fileprivate var body: some View {
    WithViewStore(store) { viewStore in
      VStack(alignment: .leading, spacing: 4) {
        Text("앱 버전 v\(viewStore.state.appVersion)")
          .font(.b16)
          .foregroundColor(DesignSystem.Colors.grey100)
        
        Text(viewStore.state.appVersionDescription)
          .font(.r14)
          .foregroundColor(DesignSystem.Colors.grey80)
      }
      .padding(.top, 16)
      .padding(.horizontal, 24)
    }
  }
}

// MARK: - 업데이트 버튼
private struct UpdateButtonView: View {
  private let store: Store<SettingState, SettingAction>
  
  fileprivate init(store: Store<SettingState, SettingAction>) {
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

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
        
        NameEditView(store: store)
          .padding(.top, 64)
          .padding(.bottom, 84)
        
        SettingRow(title: "모드 선택", subTitle: " ") {
          viewStore.send(.navigateModeSelection)
        }
        
        SettingRow(title: "앱 버전", subTitle: " ") {
          viewStore.send(.navigateAppVersion)
        }
        
        Spacer()
      }
    }
    .navigationBarHidden(true)
  }
}

private struct NameEditView: View {
  private let store: Store<SettingState, SettingAction>
  
  fileprivate init(store: Store<SettingState, SettingAction>) {
    self.store = store
  }
  
  fileprivate var body: some View {
    WithViewStore(store) { viewStore in
      HStack(spacing: 0) {
        Spacer()
        
        Text(viewStore.state.nickname)
          .font(.b24)
          .foregroundColor(DesignSystem.Colors.grey100)
          
        Spacer().frame(width: 8)
        
        DesignSystem.Icons.iconOutlinedEdit
          .resizable()
          .frame(width: 20, height: 20)
        
        Spacer()
      }
    }
  }
}

private struct SettingRow: View {
  fileprivate let title: String
  fileprivate let subTitle: String
  fileprivate let action: () -> Void
  
  fileprivate var body: some View {
    Button(action: action) {
      VStack {
        Spacer().frame(height: 16)
        row
        Spacer().frame(height: 16)
      }
    }
  }
  
  fileprivate var row: some View {
    HStack(spacing: 0) {
      Spacer().frame(width: 27)
      
      Text(title)
        .font(.r16)
        .foregroundColor(.black)
      
      Spacer()
      
      Text(subTitle)
        .font(.r14)
        .foregroundColor(DesignSystem.Colors.grey70)
      
      Spacer().frame(width: 14)
      
      DesignSystem.Icons.iconChevronRightBig
      
      Spacer().frame(width: 24)
    }
  }
}

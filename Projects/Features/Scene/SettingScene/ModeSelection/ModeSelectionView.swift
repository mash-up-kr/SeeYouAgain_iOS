//
//  ModeSelectionView.swift
//  Splash
//
//  Created by 김영균 on 2023/08/06.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Common
import ComposableArchitecture
import DesignSystem
import SwiftUI

public struct ModeSelectionView: View {
  private let store: Store<ModeSelectionState, ModeSelectionAction>
  
  public init(store: Store<ModeSelectionState, ModeSelectionAction>) {
    self.store = store
  }
  
  public var body: some View {
    WithViewStore(store) { viewStore in
      VStack(spacing: 0) {
        TopNavigationBar(
          title: "모드 선택",
          leftIcon: DesignSystem.Icons.iconNavigationLeft,
          leftIconButtonAction: {
            viewStore.send(.backButtonTapped)
          }
        )
        
        Spacer()
          .frame(height: 32)
        
        title
          .padding(.horizontal, 24)
        
        Spacer()
          .frame(height: 48)
        
        // 모드 선택 카드
        modeCards
          .padding(.horizontal, 24)
        
        Spacer()
        
        BottomButton(title: "변경") {
          viewStore.send(.changeButtonTapped)
        }
        .padding(.bottom, 8)
      }
    }
    .navigationBarHidden(true)
  }
  
  private var title: some View {
    HStack{
      Text("뉴스를 어떤 기준으로 나눌까요?")
        .font(.b24)
        .foregroundColor(DesignSystem.Colors.grey90)
      Spacer()
    }
  }
  
  private var modeCards: some View {
    HStack(spacing: 8) {
      ModeRow(mode: .basic, store: store.scope(state: \.basicModeIsSelected))
      ModeRow(mode: .interestCompany, store: store.scope(state: \.intersestCompanyModeIsSelected))
    }
  }
}

// MARK: 모드 선택 카드
private struct ModeRow: View {
  private let mode: Mode
  private let store: Store<Bool, ModeSelectionAction>
  
  fileprivate init(mode: Mode, store: Store<Bool, ModeSelectionAction>) {
    self.mode = mode
    self.store = store
  }
  
  fileprivate var body: some View {
    WithViewStore(store) { viewStore in
      ZStack(alignment: .topTrailing) {
        card
        (viewStore.state ? DesignSystem.Icons.iconModeSelect : DesignSystem.Icons.iconModeDeselect)
          .offset(x: -12, y: 12)
      }
    }
  }
  
  private var card: some View {
    WithViewStore(store) { viewStore in
      VStack {
        // 임시 모드 아이콘
        (viewStore.state ? mode.selectedIcon : mode.deselectedIcon)
        
        Spacer()
          .frame(height: 16)
        
        // 모드 이름
        title
          .padding(.horizontal, 16)
        
        Spacer()
          .frame(height: 6)
        
        // 모드 설명
        description
          .padding(.horizontal, 16)
      }
      .padding(.vertical, 24)
      .background(viewStore.state ? DesignSystem.Colors.blue50 : DesignSystem.Colors.grey20)
      .cornerRadius(12)
      .overlay(
        RoundedRectangle(cornerRadius: 12)
          .inset(by: 1)
          .stroke(
            viewStore.state ? DesignSystem.Colors.blue200 : DesignSystem.Colors.grey30,
            lineWidth: 2
          )
      )
      .onTapGesture {
        viewStore.send(.modeButtonTapped(mode))
      }
    }
  }
  
  private var title: some View {
    HStack {
      Text(mode.title)
        .font(.b18)
        .foregroundColor(DesignSystem.Colors.grey100)
      Spacer()
    }
  }
  
  private var description: some View {
    HStack {
      Text(mode.description)
        .font(.r13)
        .foregroundColor(DesignSystem.Colors.grey70)
        .multilineTextAlignment(.leading)
      Spacer()
    }
  }
}

fileprivate extension Mode {
  var selectedIcon: Image {
    switch self {
    case .basic:
      return DesignSystem.Icons.iconBasicModeSelected
      
    case .interestCompany:
      return DesignSystem.Icons.iconCompanyModeSelected
    }
  }
  
  var deselectedIcon: Image {
    switch self {
    case .basic:
      return DesignSystem.Icons.iconBasicModeDeselected
      
    case .interestCompany:
      return DesignSystem.Icons.iconCompanyModeDeselected
    }
  }
}

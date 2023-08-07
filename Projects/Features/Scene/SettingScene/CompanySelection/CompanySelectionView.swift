//
//  CompanySelectionView.swift
//  Splash
//
//  Created by 김영균 on 2023/08/07.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import ComposableArchitecture
import DesignSystem
import SwiftUI

public struct CompanySelectionView: View {
  private let store: Store<CompanySelectionState, CompanySelectionAction>
  
  public init(store: Store<CompanySelectionState, CompanySelectionAction>) {
    self.store = store
  }
  
  public var body: some View {
    WithViewStore(store) { viewStore in
      VStack(spacing: 0) {
        TopNavigationBar(
          title: "관심기업 모드",
          leftIcon: DesignSystem.Icons.iconNavigationLeft,
          leftIconButtonAction: {
            viewStore.send(.backButtonTapped)
          }
        )
        
        Spacer().frame(height: 32)
        
        // 타이틀
        title
          .padding(.horizontal, 24)
        
        Spacer().frame(height: 8)
        
        // 선택된 기업 리스트
        subtitle
          .padding(.horizontal, 24)
        
        Spacer()
        
        Text("원하는 기업이 없나요?")
          .font(.r14)
          .foregroundColor(DesignSystem.Colors.grey50)
          .onTapGesture {
            viewStore.send(.presentBottomSheet)
          }
        
        Spacer().frame(height: 32)
        
        BottomButton(title: "선택") {
          viewStore.send(.selectButtonTapped)
        }
        .padding(.bottom, 8)
      }
    }
    .emailGuideBottomSheet(store: store)
    .navigationBarHidden(true)
  }
  
  private var title: some View {
    HStack {
      Text("관심있는 기업을\n선택해주세요")
        .font(.b24)
        .foregroundColor(DesignSystem.Colors.grey90)
        .multilineTextAlignment(.leading)
      
      Spacer()
    }
  }
  
  private var subtitle: some View {
    WithViewStore(store, observe: \.selectedCompaniesText) { viewStore in
      HStack(spacing: 8) {
        Text("선택된 기업")
          .font(.r14)
          .foregroundColor(DesignSystem.Colors.grey70)
        
        Text(viewStore.state)
          .font(.b14)
          .foregroundColor(DesignSystem.Colors.blue200)
          .multilineTextAlignment(.leading)
        
        Spacer()
      }
    }
  }
}

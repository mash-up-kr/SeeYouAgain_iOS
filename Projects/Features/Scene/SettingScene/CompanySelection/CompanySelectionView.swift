//
//  CompanySelectionView.swift
//  Splash
//
//  Created by 김영균 on 2023/08/07.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import ComposableArchitecture
import DesignSystem
import Models
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
        
        // 타이틀
        title
          .padding(.horizontal, 24)
          .padding(.top, 32)
        
        // 선택된 기업 리스트
        subtitle
          .padding(.horizontal, 24)
          .padding(.top, 8)
          .frame(height: 80, alignment: .topLeading)
        
        CompanyList(store: store)
          .padding(.top, 16)
        
        Spacer()
        
        Text("원하는 기업이 없나요?")
          .font(.r14)
          .foregroundColor(DesignSystem.Colors.grey50)
          .onTapGesture {
            viewStore.send(.presentBottomSheet)
          }
        
        BottomButton(title: "선택") {
          viewStore.send(.selectButtonTapped)
        }
        .padding(.bottom, 8)
        .padding(.top, 32)
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
      HStack(alignment: .top, spacing: 8) {
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

private struct CompanyList: View {
  private let store: Store<CompanySelectionState, CompanySelectionAction>
  private let logoSize = (UIScreen.main.bounds.width - 184)
  fileprivate init(store: Store<CompanySelectionState, CompanySelectionAction>) {
    self.store = store
  }
  
  fileprivate var body: some View {
    WithViewStore(store) { viewStore in
      ScrollView(.horizontal, showsIndicators: false) {
        HStack(alignment: .center, spacing: 40) {
          Spacer().frame(width: (UIScreen.main.bounds.width - 272) / 2) // (screensize - logosize - padding * 2) / 2
          companyLogos
          Spacer().frame(width: (UIScreen.main.bounds.width - 272) / 2)
        }
      }
    }
  }
  
  private var companyLogos: some View {
    WithViewStore(store) { viewStore in
      ForEach(viewStore.allCompanies, id: \.self) { company in
        VStack(spacing: 0) {
          ZStack(alignment: .topTrailing) {
            company.logo
            
            (viewStore.state.selectedCompanies.contains(company) ?
              DesignSystem.Icons.iconCheckCircleGradientBlue :
              DesignSystem.Icons.iconCheckCircleGradientWhite)
            .offset(x: 16, y: -12)
          }
          .onTapGesture {
            viewStore.send(.companyButtonTapped(company))
          }
          
          Spacer()
            .frame(height: 48)
          
          Text(company.rawValue)
            .font(.b18)
            .foregroundColor(DesignSystem.Colors.grey100)
          
          Spacer().frame(height: 7)
          
          Text(company.description)
            .font(.r14)
            .foregroundColor(DesignSystem.Colors.grey60)
        }
      }
    }
  }
}

extension Company {
  var logo: Image {
    switch self {
    case .naver:
      return DesignSystem.Icons.iconNaver
    case .kakao:
      return DesignSystem.Icons.iconKakao
    case .line:
      return DesignSystem.Icons.iconLine
    case .coupang:
      return DesignSystem.Icons.iconCoupang
    case .wooah:
      return DesignSystem.Icons.iconWoowabros
    case .carrot:
      return DesignSystem.Icons.iconDaangn
    case .toss:
      return DesignSystem.Icons.iconVibariperublika
    case .samsung:
      return DesignSystem.Icons.iconSamsungElectronics
    case .hyundai:
      return DesignSystem.Icons.iconHyundaiMotor
    case .cj:
      return DesignSystem.Icons.iconCjCheilJedang
    case .korea_elec:
      return DesignSystem.Icons.iconKoreaElectricPower
    case .lg_elec:
      return DesignSystem.Icons.iconLgElectronics
    case .korea_gas:
      return DesignSystem.Icons.iconKoreaGasCorporation
    case .sk_hynics:
      return DesignSystem.Icons.iconSkHynix
    }
  }
}

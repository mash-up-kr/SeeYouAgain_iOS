//
//  CompanySelectionCore.swift
//  Splash
//
//  Created by 김영균 on 2023/08/07.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Combine
import Common
import ComposableArchitecture
import Foundation
import Services

public enum Company: String, Equatable, CaseIterable {
  case naver = "네이버"
  case kakao = "카카오"
  case line = "라인"
  case coupang = "쿠팡"
  case woowabros = "우아한형제들"
  case daangn = "당근마켓"
  case vibariperublika = "비바리퍼블리카"
  case samsungElectronics = "삼성전자"
  case hyundaiMotor = "현대자동차"
  case cjCheilJedang = "CJ제일제당"
  case koreaElectricPower = "한국전력공사"
  case lgElectronics = "LG전자"
  case koreaGasCorporation = "한국가스공사"
  case skHynix = "SK하이닉스"
}

public struct CompanySelectionState: Equatable {
  var allCompanies: [Company] = Company.allCases  // 전체 기업 목록
  var selectedCompanies: [Company] = [] // 선택된 기업 목록
  var selectedCompaniesText: String {
    return selectedCompanies.map { $0.rawValue }.joined(separator: " ")
  }
  var bottomSheetIsPresented: Bool = false  // 원하는 기업이 없나요 바텀시트 상태
  
  public init() {}
}

public enum CompanySelectionAction: Equatable {
  // MARK: - User Action
  case backButtonTapped
  case companyButtonTapped(Company)
  case selectButtonTapped
  case presentBottomSheet // 원하는 기업이 없나요 바텀 시트 오픈 액션
  
  // MARK: - Inner Business Action
  case _onAppear
  
  // MARK: - Inner SetState Action
  case _setBottomSheetIsPresented(Bool)
}

public struct CompanySelectionEnvironment {
  public init() {}
}

public let companySelectionReducer: Reducer<
  CompanySelectionState,
  CompanySelectionAction,
  CompanySelectionEnvironment
> = Reducer { state, action, env in
  switch action {
  case .backButtonTapped:
    return .none
    
  case let .companyButtonTapped(company):
    if state.selectedCompanies.contains(company) {
      state.selectedCompanies.removeAll(where: { $0 == company })
    } else {
      state.selectedCompanies.append(company)
    }
    return .none
    
  case .selectButtonTapped:
    return .none
    
  case .presentBottomSheet:
    state.bottomSheetIsPresented = true
    return .none
    
  case ._onAppear:
    return .none
    
  case let ._setBottomSheetIsPresented(isPresented):
    state.bottomSheetIsPresented = isPresented
    return .none
  }
}

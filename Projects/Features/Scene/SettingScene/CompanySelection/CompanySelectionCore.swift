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
import Models
import Services

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
  case companySelectCompleted
  
  // MARK: - Inner Business Action
  case _onAppear
  
  // MARK: - Inner SetState Action
  case _setBottomSheetIsPresented(Bool)
}

public struct CompanySelectionEnvironment {
  fileprivate let settingService: SettingService
  fileprivate let userDefaultsService: UserDefaultsService
  
  public init(
    settingService: SettingService = .live,
    userDefaultsService: UserDefaultsService = .live
  ) {
    self.settingService = settingService
    self.userDefaultsService = userDefaultsService
  }
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
    let companies = state.selectedCompanies.map { $0.englishName }
    return env.settingService.addInterstCompanies(companies)
      .catchToEffect()
      .flatMap { result -> Effect<CompanySelectionAction, Never> in
        switch result {
        case .success:
          return Effect(value: .companySelectCompleted)
        case .failure:
          return .none
        }
      }
      .eraseToEffect()
      
    
  case .presentBottomSheet:
    state.bottomSheetIsPresented = true
    return .none
    
  case .companySelectCompleted:
    return Effect.merge(
      env.settingService.changeMode(["MY_COMPANY"]).fireAndForget(),
      env.userDefaultsService.save(UserDefaultsKey.hasCompanyModeHistory, true).fireAndForget()
    )
    
  case ._onAppear:
    return .none
    
  case let ._setBottomSheetIsPresented(isPresented):
    state.bottomSheetIsPresented = isPresented
    return .none
  }
}

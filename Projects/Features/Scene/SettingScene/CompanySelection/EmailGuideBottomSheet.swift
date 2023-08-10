//
//  EmailGuideBottomSheet.swift
//  Setting
//
//  Created by 김영균 on 2023/08/07.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Common
import ComposableArchitecture
import DesignSystem
import SwiftUI

struct EmailGuideBottomSheet: ViewModifier {
  private let store: Store<CompanySelectionState, CompanySelectionAction>
  
  init(store: Store<CompanySelectionState, CompanySelectionAction>) {
    self.store = store
  }
  
  func body(content: Content) -> some View {
    WithViewStore(store) { viewStore in
      content
        .bottomSheet(
          isPresented: viewStore.binding(
            get: \.bottomSheetIsPresented,
            send: CompanySelectionAction._setBottomSheetIsPresented
          ),
          headerArea: { headerArea },
          content: { self.content },
          bottomArea: { bottomArea }
        )
    }
  }
  
  private var headerArea: some View {
    HStack {
      Text("원하는 기업이 없나요?")
        .font(.b18)
        .foregroundColor(DesignSystem.Colors.grey100)
      Spacer()
    }
    .padding(.horizontal, 24)
  }
  
  private var currentDate = Date().toFormattedString(format: "yyyy년 MM월 dd일")
  
  private var content: some View {
    WithViewStore(store, observe: \.allCompanies.count) { viewStore in
      HStack {
        Text(
          """
          현재 \(currentDate) 기준으로 \(viewStore.state)개의 기업이 있어요! \
          회사는 더 추가될 예정이예요. 추가되길 원하는 회사를 알려주세요.
          aaaaa@gmail.com
          """
        )
        .font(.r16)
        .foregroundColor(DesignSystem.Colors.grey80)
        .multilineTextAlignment(.leading)
        
        Spacer()
      }
    }
  }
  
  private var bottomArea: some View {
    WithViewStore(store.stateless) { viewStore in
      BottomButton(
        title: "확인",
        action: { viewStore.send(._setBottomSheetIsPresented(false)) }
      )
    }
  }
}

// MARK: 바텀 시트 모디파이어 Extension
extension View {
  func emailGuideBottomSheet(store: Store<CompanySelectionState, CompanySelectionAction>) -> some View {
    modifier(EmailGuideBottomSheet(store: store))
  }
}

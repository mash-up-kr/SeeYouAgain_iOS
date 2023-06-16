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
      VStack(spacing: 0) {
        TopNavigationBar(
          rightIcon: DesignSystem.Icons.iconSetting,
          rightIconButtonAction: {
            viewStore.send(.settingButtonTapped)
          }
        )
        
        ZStack(alignment: .topTrailing) {
          // TODO: 지구본 이미지 확정 시 수정 필요
          DesignSystem.Images.earth
            .frame(width: 106, height: 106)
            .padding(.trailing, 24)
          
          MyInfoView(
            store: store.scope(
              state: \.info,
              action: MyPageAction.myInfo
            )
          )
          .padding(.horizontal, 24)
          
          Spacer()
        }
        .padding(.top, 32)
        
        Spacer()
          .frame(height: 39)
        
        // TODO: 디자인시스템 색상 정의되지 않은 부분으로 수정 필요
        DesignSystem.Colors.blue100
      }
    }
    .navigationBarHidden(true)
    .edgesIgnoringSafeArea(.bottom)
  }
}

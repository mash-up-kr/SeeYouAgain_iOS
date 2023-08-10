//
//  TodayShortsCardView.swift
//  ShortStorageNewsList
//
//  Created by 안상희 on 2023/06/18.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Common
import ComposableArchitecture
import DesignSystem
import SwiftUI

struct TodayShortsCardView: View {
  private let store: Store<TodayShortsCardState, TodayShortsCardAction>
  
  init(store: Store<TodayShortsCardState, TodayShortsCardAction>) {
    self.store = store
  }
  
  var body: some View {
    WithViewStore(store) { viewStore in
      HStack(alignment: .top, spacing: 0) {
        CategoryType(uppercasedName: viewStore.state.shortsNews.category)?.image

        Spacer()
          .frame(width: 16)

        HStack {
          Text(viewStore.state.shortsNews.hashtagString())
            .font(.b16)
            .foregroundColor(DesignSystem.Colors.grey90)
          Spacer()
        }
        
        if viewStore.isCardSelectable {
          Spacer()
            .frame(width: 16)
          
          Button {
            viewStore.send(.rightButtonTapped)
          } label: {
            DesignSystem.Icons.iconChevronRight
              .frame(width: 16, height: 16)
          }
        }
      }
      .frame(maxWidth: .infinity)
      .padding(.horizontal, 16)
      .padding(.vertical, 20)
      .background(DesignSystem.Colors.grey20)
      .cornerRadius(16)
      .onTapGesture {
        if viewStore.isCardSelectable {
          viewStore.send(.cardTapped)
        }
      }
    }
  }
}

fileprivate extension CategoryType {
  var image: Image {
    switch self {
    case .politics:
      return DesignSystem.Images.cardPolitics
    case .economic:
      return DesignSystem.Images.cardEconomics
    case .society:
      return DesignSystem.Images.cardSociety
    case .world:
      return DesignSystem.Images.cardWorld
    case .culture:
      return DesignSystem.Images.cardCulture
    case .science:
      return DesignSystem.Images.cardIt
    case .naver:
      return DesignSystem.Images.naverNewscard
    case .kakao:
      return DesignSystem.Images.kakaoNewscard
    case .line:
      return DesignSystem.Images.lineNewscard
    case .coupang:
      return DesignSystem.Images.coupangNewscard
    case .wooah:
      return DesignSystem.Images.worldNewscard
    case .carrot:
      return DesignSystem.Images.daangnNewscard
    case .toss:
      return DesignSystem.Images.vibariperublikaNewscard
    case .samsung:
      return DesignSystem.Images.samsungElectronicsNewscard
    case .hyundai:
      return DesignSystem.Images.hyundaiMotorNewscard
    case .cj:
      return DesignSystem.Images.cjCheilJedangNewscard
    case .korea_elec:
      return DesignSystem.Images.koreaElectricPowerNewscard
    case .lg_elec:
      return DesignSystem.Images.lgElectronicsNewscard
    case .korea_gas:
      return DesignSystem.Images.koreaGasCorporationNewscard
    case .sk_hynics:
      return DesignSystem.Images.skHynixNewscard
    }
  }
}

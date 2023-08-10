//
//  MyAchievementShareView.swift
//  MyPage
//
//  Created by 김영균 on 2023/07/29.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Common
import ComposableArchitecture
import DesignSystem
import Foundation
import Models
import SwiftUI

public struct AchievementShareView: View {
  private let store: Store<AchievementShareState, AchievementShareAction>
  
  public init(store: Store<AchievementShareState, AchievementShareAction>) {
    self.store = store
  }
  
  public var body: some View {
    WithViewStore(store) { viewStore in
      VStack(spacing: 0) {
        dismissButton
          .padding(.top, 14)
        
        contents
          .padding(.top, 77)
        
        Spacer()
        
        BottomButton(
          title: "공유하기",
          action: {
            viewStore.send(.shareButtonDidTapped)
          }
        )
        .padding(.bottom, 48)
      }
      .background(
        DesignSystem.Images.bgRecord
          .resizable()
          .aspectRatio(contentMode: .fill)
          .edgesIgnoringSafeArea(.all)
      )
      .background(
        ActivityView(
          isPresented: viewStore.binding(
            get: \.activityViewIsPresented,
            send: AchievementShareAction._setActivityViewIsPresented
          ),
          activityItems: [viewStore.achievementType.shareImage].compactMap { $0 },
          completion: { viewStore.send(.shareCompleted) }
        )
      )
    }
  }
  
  private var dismissButton: some View {
    WithViewStore(store.stateless) { viewStore in
      HStack(spacing: 0) {
        Spacer()
        
        DesignSystem.Icons.iconNavigationDismiss
          .renderingMode(.template)
          .resizable()
          .frame(width: 32, height: 32)
          .foregroundColor(DesignSystem.Colors.white)
          .onTapGesture {
            viewStore.send(.dismissButtonDidTapped)
          }
        
        Spacer().frame(width: 16)
      }
    }
  }
  
  private var contents: some View {
    WithViewStore(store, observe: \.achievementType) { viewStore in
      HStack {
        Spacer()
        
        VStack(spacing: 0) {
          viewStore.state.shareIcon
          
          Text(viewStore.state.rawValue)
            .font(.b28)
            .foregroundColor(DesignSystem.Colors.white)
            .padding(.top, 40)
          
          Text(viewStore.state.shareDescription)
            .font(.r18)
            .foregroundColor(DesignSystem.Colors.white)
            .multilineTextAlignment(.center)
            .padding(.top, 10)
        }
        
        Spacer()
      }
    }
  }
}

fileprivate extension AchievementType {
  var shareIcon: Image {
    switch self {
    case .threeDaysContinuousAttendance:
      return DesignSystem.Icons.iconShareThreeDays
      
    case .explorer:
      return DesignSystem.Icons.iconShareExplorer
      
    case .kingOfSharing:
      return DesignSystem.Icons.iconShareSharing
      
    case .excitedSave:
      return DesignSystem.Icons.iconShareExcitedSave
      
    case .firstAllReadShorts:
      return DesignSystem.Icons.iconShareHalfstart
      
    case .changeMode:
      return DesignSystem.Icons.iconShareRespectTaste
      
    case .tenDaysContinuousAttendance:
      return DesignSystem.Icons.iconShareTenDaysAttendance
    }
  }
  
  var shareImage: UIImage? {
    switch self {
    case .threeDaysContinuousAttendance:
      return UIImage(asset: ImageAsset(name: "share_threeDays"))
      
    case .explorer:
      return UIImage(asset: ImageAsset(name: "share_explorer"))
      
    case .kingOfSharing:
      return UIImage(asset: ImageAsset(name: "share_sharing"))
      
    case .excitedSave:
      return UIImage(asset: ImageAsset(name: "share_excited_save"))
      
    case .firstAllReadShorts:
      return UIImage(asset: ImageAsset(name: "share_halfstart"))
      
    case .changeMode:
      return UIImage(asset: ImageAsset(name: "share_respect_taste"))
      
    case .tenDaysContinuousAttendance:
      return UIImage(asset: ImageAsset(name: "share_tenDaysAttendance"))
    }
  }
}

//
//  ShortStorageNewsListView.swift
//  Scene
//
//  Created by GREEN on 2023/04/28.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import ComposableArchitecture
import DesignSystem
import SwiftUI

public struct ShortStorageNewsListView: View {
  private let store: Store<ShortStorageNewsListState, ShortStorageNewsListAction>
  
  public init(store: Store<ShortStorageNewsListState, ShortStorageNewsListAction>) {
    self.store = store
  }
  
  public var body: some View {
    WithViewStore(store) { viewStore in
      VStack(spacing: 0) {
        TopNavigationBar(
          title: "오늘의 숏스",
          leftIcon: DesignSystem.Icons.iconNavigationLeft,
          leftIconButtonAction: {
            viewStore.send(.backButtonTapped)
          },
          rightText: viewStore.shortslistCount == 0 ? nil : (viewStore.state.isInEditMode ? "삭제" : "편집"),
          rightIconButtonAction: {
            if viewStore.shortslistCount != 0  {
              viewStore.send(.editButtonTapped)
            }
          }
        )
        
        ScrollView {
          Spacer()
            .frame(height: 40)
          
          // 날짜
          Text(Date().fullDateToString())
            .font(.b14)
            .foregroundColor(DesignSystem.Colors.grey90)
            .padding(.horizontal, 105)
          
          Spacer()
            .frame(height: 8)
          
          // 숏스 수
          Text("\(viewStore.shortsClearCount)숏스")
            .font(.b24)
            .foregroundColor(
              viewStore.shortsClearCount == 0 ?
              DesignSystem.Colors.grey60 : DesignSystem.Colors.grey100
            )
            .padding(.horizontal, 24)
          
          if viewStore.shortslistCount == 0 {
            // 오늘 저장한 숏스 없는 경우
            Spacer()
              .frame(height: 128)
            
            Text("오늘은 아직 저장한 뉴스가 없어요\n뉴스를 보고 마음에 드면 저장해보세요")
              .multilineTextAlignment(.center)
              .font(.b14)
              .foregroundColor(DesignSystem.Colors.grey70)
              .padding(.horizontal, 24)
          } else if viewStore.shortsClearCount == viewStore.shortslistCount {
            // 오늘 저장한 숏스 다 읽은 경우
            Spacer()
              .frame(height: 128)
            
            Text("오늘 저장한 뉴스를 다 읽었어요!")
              .font(.b14)
              .foregroundColor(DesignSystem.Colors.grey70)
              .padding(.horizontal, 24)
          } else {
            Spacer()
              .frame(height: 16)
            
            HStack(spacing: 4) {
              Group {
                Text("남은시간")
                  .font(.r16)
                
                // TODO: 오늘 하루 남은 시간 표시
                Text("11:06:17")
                  .font(.b16)
              }
              .foregroundColor(DesignSystem.Colors.blue200)
              
              Button {
                // TODO: 안내 사항 표시
              } label: {
                DesignSystem.Icons.iconSuggestedCircle
                  .frame(width: 16, height: 16)
              }
            }

            // TODO: 리스트 표시
          }
        }
      }
      .navigationBarHidden(true)
    }
  }
}

// TODO: 코드 위치 변경 필요
extension Date {
  func fullDateToString() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy년 M월 dd일"
    dateFormatter.locale = Locale(identifier: "ko_KR")
    dateFormatter.timeZone = TimeZone(identifier: "KST")
    return dateFormatter.string(from: self)
  }
  
  func yearMonthToString() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy년 M월"
    dateFormatter.locale = Locale(identifier: "ko_KR")
    dateFormatter.timeZone = TimeZone(identifier: "KST")
    return dateFormatter.string(from: self)
  }
}

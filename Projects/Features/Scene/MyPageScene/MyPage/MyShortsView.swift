//
//  MyShortsView.swift
//  MyPage
//
//  Created by 안상희 on 2023/06/16.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import ComposableArchitecture
import DesignSystem
import SwiftUI

struct MyShortsView: View {
  let store: Store<MyShortsState, MyShortsAction>
  
  var body: some View {
    WithViewStore(store) { viewStore in
      VStack(spacing: 16) {
        HStack(spacing: 0) {
          Group {
            DesignSystem.Icons.iconStar
              .frame(width: 12, height: 12)
            
            Spacer()
              .frame(width: 4)
            
            Text("이번 달 ")
              .font(.r14)
            Text("\(viewStore.myShorts.totalShortsCount)숏스 ")
              .font(.b14)
            Text("중")
              .font(.r14)
            
          }
          .foregroundColor(DesignSystem.Colors.grey90)
          
          Spacer()
        }
        
        HStack(spacing: 16) {
          Button {
            viewStore.send(.shortShortsButtonTapped)
          } label: {
            ShortsInfoView(
              title: "오늘의 숏스",
              count: 5,
              fontColor: DesignSystem.Colors.blue200
            )
          }
          
          Rectangle()
          
          .size(width: 1, height: 36)
            .fill(DesignSystem.Colors.grey30)
            .frame(width: 1, height: 36)
          

          Button {
            viewStore.send(.longShortsButtonTapped)
          } label: {
            ShortsInfoView(
              title: "오래 간직할 숏스",
              count: 56,
              fontColor: DesignSystem.Colors.grey80
            )
          }
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 12)
        .background(Color.white)
        .cornerRadius(8)
      }
      .padding(.horizontal, 20)
      .padding(.vertical, 16)
      .background(DesignSystem.Colors.grey20)
      .overlay(
        RoundedRectangle(cornerRadius: 8)
          .stroke(
            LinearGradient(
              gradient: Gradient(colors: [Color.gray, Color.gray]),
              startPoint: .topLeading,
              endPoint: .bottomTrailing
            ),
            lineWidth: 1.4
          )
      )
    }
    .background(Color.white)
    .cornerRadius(8)
  }
}

fileprivate struct ShortsInfoView: View {
  private let title: String
  private let count: Int
  private let fontColor: Color
  
  fileprivate init(
    title: String,
    count: Int,
    fontColor: Color) {
      self.title = title
      self.count = count
      self.fontColor = fontColor
  }
  
  fileprivate var body: some View {
    VStack(spacing: 8) {
      Text(title)
        .font(.r14)
        .foregroundColor(DesignSystem.Colors.grey70)
      
      Text("\(count)")
        .font(.b18)
        .foregroundColor(fontColor)
    }
    .frame(width: 103, height: 47)
    .background(Color.white)
  }
}

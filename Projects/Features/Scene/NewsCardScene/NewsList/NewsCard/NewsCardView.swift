//
//  NewsCardView.swift
//  NewsList
//
//  Created by 안상희 on 2023/06/24.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import ComposableArchitecture
import DesignSystem
import SwiftUI

public struct NewsCardView: View {
  private let store: Store<NewsCardState, NewsCardAction>
  
  public init(store: Store<NewsCardState, NewsCardAction>) {
    self.store = store
  }
  
  public var body: some View {
    WithViewStore(store) { viewStore in
      HStack(alignment: .top, spacing: 0) {
        if let imageUrl = viewStore.state.news.thumbnailImageUrl {
          // TODO: 서버에서 받아오는 URL 이미지로 변경 필요
          AsyncImage(url: URL(string: imageUrl)) { phase in
            phase
              .resizable()
              .frame(width: 56, height: 56)
              .clipShape(Circle())
          } placeholder: {
            ProgressView()
          }
          
          Spacer()
            .frame(width: 16)
        }
        
        NewsDataView(news: viewStore.news)
        
        Button {
          viewStore.send(.rightButtonTapped)
        } label: {
          DesignSystem.Icons.iconChevronRight
            .frame(width: 16, height: 16)
        }
      }
      .frame(maxWidth: .infinity)
      .padding(.horizontal, 16)
      .padding(.vertical, 20)
      .background(DesignSystem.Colors.grey20)
      .cornerRadius(16)
      .onTapGesture {
        viewStore.send(.cardTapped)
      }
    }
  }
}

private struct NewsDataView: View {
  private let news: News
  
  fileprivate init(news: News) {
    self.news = news
  }
  
  var body: some View {
    VStack(spacing: 0) {
      HStack(spacing: 0) {
        Text(news.title)
          .font(.b16)
          .foregroundColor(DesignSystem.Colors.grey90)
        
        Spacer()
      }
      
      Spacer()
        .frame(height: 10)
      
      HStack(spacing: 4) {
        Text(news.press)
          .font(.r14)
          .foregroundColor(DesignSystem.Colors.grey50)
        
        Text(news.type)
          .font(.r12)
          .foregroundColor(DesignSystem.Colors.grey20)
          .padding(.horizontal, 6)
          .padding(.vertical, 2)
          .background(DesignSystem.Colors.economic)
          .cornerRadius(26)
        
        Spacer()
      }
      
      Spacer()
        .frame(height: 4)
      
      HStack(spacing: 4) {
        DesignSystem.Icons.iconCalendar
          .frame(width: 14, height: 14)
        
        Text(news.writtenDateTime)
          .font(.r13)
          .foregroundColor(DesignSystem.Colors.grey60)
        
        Spacer()
      }
    }
  }
}

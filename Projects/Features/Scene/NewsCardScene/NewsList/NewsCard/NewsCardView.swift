//
//  NewsCardView.swift
//  NewsList
//
//  Created by 안상희 on 2023/06/24.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Common
import ComposableArchitecture
import DesignSystem
import Models
import NukeUI
import SwiftUI

public struct NewsCardView: View {
  private let store: Store<NewsCardState, NewsCardAction>
  
  public init(store: Store<NewsCardState, NewsCardAction>) {
    self.store = store
  }
  
  public var body: some View {
    WithViewStore(store) { viewStore in
      HStack(alignment: .top, spacing: 0) {
        if let imageUrl = viewStore.state.news.thumbnailImageUrl, imageUrl != "null" {
          LazyImage(url: URL(string: imageUrl)) { state in
            if let image = state.image {
              image
                .resizable()
                .frame(width: 56, height: 56)
                .clipShape(Circle())
            }
          }

          Spacer()
            .frame(width: 16)
        }
        
        NewsDataView(news: viewStore.state.news)
        
        Button {
          viewStore.send(.rightButtonTapped)
        } label: {
          DesignSystem.Icons.iconChevronRight
            .frame(width: 16, height: 16)
        }
      }
      .frame(maxWidth: .infinity)
      .padding(20)
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
  
  fileprivate var body: some View {
    VStack(spacing: 0) {
      HStack(spacing: 0) {
        Text(news.title)
          .font(.b16)
          .foregroundColor(DesignSystem.Colors.grey90)
          .lineLimit(2)
        
        Spacer()
      }
      
      Spacer()
        .frame(height: 10)
      
      HStack(spacing: 4) {
        Text(news.press)
          .font(.r14)
          .foregroundColor(DesignSystem.Colors.grey50)

        CategoryView(
          category: CategoryType(uppercasedName: news.category)!.rawValue,
          color: CategoryType(uppercasedName: news.category)!.color
        )
        
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

fileprivate extension CategoryType {
  var color: Color {
    switch self {
    case .politics:
      return DesignSystem.Colors.politics
    case .economic:
      return DesignSystem.Colors.economic
    case .society:
      return DesignSystem.Colors.society
    case .world:
      return DesignSystem.Colors.world
    case .culture:
      return DesignSystem.Colors.culture
    case .science:
      return DesignSystem.Colors.science
    }
  }
}

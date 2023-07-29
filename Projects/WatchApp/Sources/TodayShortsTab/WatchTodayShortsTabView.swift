//
//  WatchTodayShortsTabView.swift
//  Splash
//
//  Created by 리나 on 2023/07/29.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import CommonWatchOS
import ComposableArchitecture
//import DesignSystem
import ModelsWatchOS
import SwiftUI

struct WatchTodayShortsTabView: View {
  private let store: Store<WatchTodayShortsTabState, WatchTodayShortsTabAction>
  
  public init(store: Store<WatchTodayShortsTabState, WatchTodayShortsTabAction>) {
    self.store = store
  }
  
  @State private var isPresentingDetail = false

  var body: some View {
    WithViewStore(store) { viewStore in
      NavigationView {
        VStack {
          List {
            Section(header: headerView) {
              ForEach(viewStore.state.newsCardList, id: \.self) { newsCard in
                Button {
                  isPresentingDetail = true
                } label: {
                  WatchTodayShortsCell(with: newsCard)
                }
                .fullScreenCover(isPresented: $isPresentingDetail, content: {
                  WatchTodayShortsDetailView(with: newsCard)
                })
              }
            }
          }
          .accentColor(.green) // 컬러
        }
      }
      .onAppear {
        viewStore.send(._viewWillAppear)
      }
    }
  }
  
  private var headerView: some View {
    VStack(alignment: .leading) {
      Text("오늘의 숏스")
        .font(.system(size: 25.0))
        .bold()
        .foregroundColor(.white)
      Spacer()
    }
    .frame(height: 32.0)
  }
}

struct WatchTodayShortsCell: View {
  let newsCard: NewsCard
  
  init(with newsCard: NewsCard) {
    self.newsCard = newsCard
  }
  
  var body: some View {
    VStack(alignment: .leading) {
      HStack {
        CategoryType(uppercasedName: newsCard.category)?.image
          .frame(width: 45.0, height: 45.0)
        
        Spacer()
        
        VStack{
          Image(systemName: "heart")
//          DesignSystem.Icons.menu
            .frame(width: 23.0, height: 23.0)
          
          Spacer()
        }
      }
      
      Text(newsCard.hashtagString())
        .font(.system(size: 15.0))
        .bold()
        .foregroundColor(.white)
    }
    .padding(.vertical, 10)
    .padding(.horizontal, 5)
  }
}

struct WatchTodayShortsDetailView: View {
  @Environment(\.presentationMode) var presentationMode
  
  let newsCard: NewsCard
  
  init(with newsCard: NewsCard) {
    self.newsCard = newsCard
  }

  var body: some View {
    VStack(alignment: .leading) {
      Text(newsCard.hashtagString())
        .font(.system(size: 20.0))
        .bold()
        .foregroundColor(.white)
        .lineLimit(2)
      
      Spacer()
      
      Button("숏스 저장") {
        print("숏스")
      }
      .foregroundColor(.white)
      .background(.gray)
      .cornerRadius(11.0)
      
      Button("폰에서 보기") {
        print("폰")
      }
      .foregroundColor(.white)
      .background(.blue)
      .cornerRadius(11.0)
    }
    .padding(.bottom, -10)
    .tabViewStyle(.page(indexDisplayMode: .never))
    .toolbar {
      ToolbarItem(placement: .cancellationAction) {
        Button {
          presentationMode.wrappedValue.dismiss()
        } label: {
          HStack {
            Image("arrow")
              .padding(.trailing, 3)
            Text("홈")
              .font(.system(size: 20))
              .foregroundColor(.blue)
          }
        }
      }
    }
  }
}

fileprivate extension CategoryType {
  var image: Image {
    return Image(systemName: "heart")
//    switch self {
//    case .politics:
//      return DesignSystem.Images.cardPolitics
//    case .economic:
//      return DesignSystem.Images.cardEconomics
//    case .society:
//      return DesignSystem.Images.cardSociety
//    case .world:
//      return DesignSystem.Images.cardWorld
//    case .culture:
//      return DesignSystem.Images.cardCulture
//    case .science:
//      return DesignSystem.Images.cardIt
//    }
  }
}

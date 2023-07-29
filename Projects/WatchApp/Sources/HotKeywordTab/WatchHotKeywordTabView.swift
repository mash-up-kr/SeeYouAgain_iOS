//
//  WatchHotKeywordTabView.swift
//  Splash
//
//  Created by 리나 on 2023/07/29.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

struct WatchHotKeywordTabView: View {
  private let store: Store<WatchHotKeywordTabState, WatchHotKeywordTabAction>
  
  public init(store: Store<WatchHotKeywordTabState, WatchHotKeywordTabAction>) {
    self.store = store
  }
  
  @State private var isPresentingDetail = false
  
  var body: some View {
    WithViewStore(store) { viewStore in
      NavigationView {
        VStack {
          List {
            Section(header: HeaderView(subTitleText: viewStore.state.subTitleText)) {
              ForEach(Array(viewStore.state.hotKeywordList.enumerated()), id: \.element.self) { index, hotKeyword in
                Button {
                  viewStore.send(._fetchKeywordNewsList(hotKeyword))
                } label: {
                  WatchHotKeywordCell(with: hotKeyword, index: index)
                }
              }
            }
          }
          .onChange(of: viewStore.state.hotKeywordNewsList) { newsList in
            if newsList.isEmpty == false {
              isPresentingDetail = true
            }
          }
          .onChange(of: isPresentingDetail) { isPresentingDetail in
            if isPresentingDetail == false {
              viewStore.send(._setHotKeywordNewsList(keyword: "", newsList: []))
            }
          }
          .accentColor(.green) // 컬러
        }
      }
      .fullScreenCover(isPresented: $isPresentingDetail) {
        WatchHotKeywordDetailView(
          isPresented: $isPresentingDetail,
          hotKeyword: viewStore.state.currentKeyword,
          newsList: viewStore.state.hotKeywordNewsList
        )
      }
      .onAppear {
        viewStore.send(._viewWillApear)
      }
    }
  }
  
  struct HeaderView: View {
    let subTitleText: String
    
    init(subTitleText: String) {
      self.subTitleText = subTitleText
    }
    
    var body: some View {
      VStack(alignment: .leading, spacing: 8.0) {
        Text("핫 키워드")
          .font(.system(size: 25.0))
          .bold()
          .foregroundColor(.white)
        
        Text(subTitleText)
          .font(.system(size: 15.0))
          .foregroundColor(.gray)
      }
      .frame(height: 50.0)
      .padding(.bottom, 14.0)
      }
  }
}

struct WatchHotKeywordCell: View {
  let hotKeyword: String
  let index: Int
  
  init(with hotKeyword: String, index: Int) {
    self.hotKeyword = hotKeyword
    self.index = index
  }
  
  var body: some View {
    VStack(alignment: .leading) {
      HStack(alignment: .center) {
        ZStack {
          Circle()
            .fill(.gray)
            .frame(width: 20.0, height: 20.0)
          
          Text("\(index + 1)")
            .font(.system(size: 15.0))
            .bold()
            .foregroundColor(.white)
        }
        .padding(.trailing, 8)
        
        Text("#\(hotKeyword)")
          .font(.system(size: 20.0))
          .foregroundColor(.white)
          .padding(.bottom, 1)
      }
    }
    .padding(.all, 5)
  }
}

struct WatchHotKeywordDetailView: View {
  @Environment(\.presentationMode) var presentationMode
  @Binding var isPresented: Bool
  
  let hotKeyword: String
  let newsList: [String]
  
  public init(
    isPresented: Binding<Bool>,
    hotKeyword: String,
    newsList: [String]
  ) {
    self._isPresented = isPresented
    self.hotKeyword = hotKeyword
    self.newsList = newsList
  }
  
  var body: some View {
    VStack(alignment: .leading) {
      Text("#\(hotKeyword)")
        .font(.system(size: 20.0))
        .bold()
        .foregroundColor(.white)
        .lineLimit(1)
      
      Spacer()
      
      if let firstNews = newsList.first {
        Text(firstNews)
          .font(.system(size: 15.0))
          .foregroundColor(.gray)
          .lineLimit(2)
      }
      
      Spacer()
      
      if let lastNews = newsList.last {
        Text(lastNews)
          .font(.system(size: 15.0))
          .foregroundColor(.gray)
          .lineLimit(2)
      }
      
      Spacer()
      
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
          isPresented = false
          //presentationMode.wrappedValue.dismiss()
        } label: {
          HStack {
            Image("arrow")
              .padding(.trailing, 3)
            Text("핫 키워드")
              .font(.system(size: 20))
              .foregroundColor(.blue)
          }
        }
      }
    }
  }
}

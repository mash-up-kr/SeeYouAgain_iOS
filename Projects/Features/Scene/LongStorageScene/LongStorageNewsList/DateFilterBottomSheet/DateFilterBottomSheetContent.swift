//
//  DateFilterBottomSheetContent.swift
//  LongStorageNewsList
//
//  Created by 안상희 on 2023/07/06.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Common
import ComposableArchitecture
import SwiftUI

struct DateFilterBottomSheetContent: View {
  private let store: Store<DateFilterBottomSheetState, DateFilterBottomSheetAction>
  
  init(store: Store<DateFilterBottomSheetState, DateFilterBottomSheetAction>) {
    self.store = store
  }
  
  var body: some View {
    WithViewStore(store) { viewStore in
      HStack {
        Picker(
          selection: viewStore.binding(
            get: \.year,
            send: DateFilterBottomSheetAction._setSelectedYear
          ),
          label: Text("")
        ) {
          ForEach(0..<viewStore.state.years.count, id: \.self) { index in
            Text("\(String(viewStore.state.years[index]))년").tag(index)
          }
        }
        .pickerStyle(.wheel)
        
        Picker(
          selection: viewStore.binding(
            get: \.month,
            send: DateFilterBottomSheetAction._setSelectedMonth
          ),
          label: Text("")
        ) {
          ForEach(0..<viewStore.state.months.count, id: \.self) { index in
            Text("\(String(viewStore.state.months[index]))월").tag(index)
          }
        }
        .pickerStyle(.wheel)
      }
    }
  }
}

struct DatePickerView: View {
  @State private var year: Int = Date().yearToInt()
  @State private var month: Int = Date().monthToInt() - 1 // 피커에서 배열 인덱스로 사용해서 1 빼줘야 해당 월이 나옴
  
  private var years: [Int] = [2023]
  private var months = [Int](1...12)
  
  var body: some View {
    HStack {
      Picker(selection: self.$year, label: Text("")) {
        ForEach(0..<self.years.count, id: \.self) { index in
          Text("\(String(self.years[index]))년").tag(index)
        }
      }
      .pickerStyle(.wheel)
      
      Picker(selection: self.$month, label: Text("")) {
        ForEach(0..<self.months.count, id: \.self) { index in
          Text("\(self.months[index])월").tag(index)
        }
      }
      .pickerStyle(.wheel)
    }
  }
}

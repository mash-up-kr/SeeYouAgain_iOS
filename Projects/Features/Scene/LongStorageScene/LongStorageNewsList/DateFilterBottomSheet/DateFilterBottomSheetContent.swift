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

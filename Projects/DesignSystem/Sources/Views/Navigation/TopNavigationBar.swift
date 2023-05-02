//
//  TopNavigationBar.swift
//  DesignSystem
//
//  Created by GREEN on 2023/04/05.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import SwiftUI

public struct TopNavigationBar: View {
  public var title: String
  public var leftIcon: Image
  public var leftText: String?
  public var leftIconButtonAction: () -> Void = {}
  
  public init(
    title: String,
    leftIcon: Image = Image(systemName: "chevron.backward"),
    leftText: String? = nil,
    leftIconButtonAction: @escaping () -> Void = {}
  ) {
    self.title = title
    self.leftIcon = leftIcon
    self.leftText = leftText
    self.leftIconButtonAction = leftIconButtonAction
  }
  
  public var body: some View {
    HStack {
      Button(action: leftIconButtonAction) {
        HStack {
          leftIcon
            .frame(width: 40, height: 40, alignment: .center)
          
          if let leftText = leftText {
            Text(leftText)
              .font(.body)
              .bold()
              .frame(height: 22, alignment: .leading)
              .padding(.leading, -16)
          }
        }
      }
      
      HStack {
        Spacer()
        Text(title)
          .font(.body)
          .bold()
          .frame(height: 22, alignment: .leading)
        Spacer()
      }
    }
    .frame(height: 48, alignment: .center)
    .background(Color.white)
  }
}

//
//  BottomButton.swift
//  DesignSystem
//
//  Created by GREEN on 2023/06/05.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import SwiftUI

public struct BottomButton: View {
  let title: String
  var disabled: Bool
  var action: () -> Void
  
  public init(
    title: String,
    disabled: Bool = false,
    action: @escaping () -> Void = {}
  ) {
    self.title = title
    self.disabled = disabled
    self.action = action
  }
  
  public var body: some View {
    HStack {
      Spacer()
        .frame(width: 20)
      
      Button(
        action: action,
        label: {
          HStack {
            Spacer()
            
            Text(title)
              .font(.r16)
              .foregroundColor(DesignSystem.Colors.white)
            
            Spacer()
          }
          .frame(height: 52)
          // TODO: - 추후 disabled에 대한 디자인 정의 시 변경될 예정
          .background(disabled ? .gray : DesignSystem.Colors.blue200)
          .cornerRadius(12)
        }
      )
      .disabled(disabled)
      
      Spacer()
        .frame(width: 20)
    }
  }
}

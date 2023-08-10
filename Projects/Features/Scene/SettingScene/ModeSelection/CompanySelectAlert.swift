//
//  CompanySelectAlert.swift
//  Setting
//
//  Created by 김영균 on 2023/08/10.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import DesignSystem
import SwiftUI

struct CompanySelectAlert: View {
  private var dismiss: (() -> Void)
  
  init(dismiss: @escaping (() -> Void)) {
    self.dismiss = dismiss
  }
  
  var body: some View {
    VStack(spacing: 0) {
      title
      
      description
        .padding(.top, 16)
      
      confirmButton
        .padding(.top, 16)
    }
    .padding(.horizontal, 20)
    .padding(.vertical, 24)
    .background(DesignSystem.Colors.white)
    .cornerRadius(12)
  }
  
  
  private var title: some View {
    HStack {
      Text("관심기업 모드는 아직 준비중이에요")
        .font(.b18)
        .foregroundColor(.black)
      Spacer()
    }
  }
  
  private var description: some View {
    HStack {
      Text("최대한 빠르게 준비할게요. 조금만 기다려주세요.")
        .font(.r14)
        .foregroundColor(DesignSystem.Colors.grey70)
        .multilineTextAlignment(.leading)
      Spacer()
    }
  }
  
  private var confirmButton: some View {
    HStack{
      Spacer()
      Button("확인", action: dismiss)
      .font(.b16)
      .foregroundColor(DesignSystem.Colors.blue200)
    }
  }
}

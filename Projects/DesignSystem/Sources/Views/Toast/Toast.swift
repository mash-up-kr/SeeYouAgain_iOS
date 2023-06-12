//
//  Toast.swift
//  DesignSystem
//
//  Created by GREEN on 2023/06/12.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import SwiftUI

struct ToastView: View {
  private var text: String?
  private var toastType: ToastType
  private var isExistText: Bool {
    text != nil
  }
  
  init(
    text: String? = nil,
    toastType: ToastType
  ) {
    self.text = text
    self.toastType = toastType
  }
  
  var body: some View {
    if isExistText {
      switch toastType {
      case .basic:
        TextWithIconToast(text: text ?? "", toastType: toastType)
          .customToastPadding(backgroundColor: toastType.backgroundColor)
        
      default:
        TextWithIconToast(text: text ?? "", toastType: toastType)
          .customToastPadding(backgroundColor: toastType.backgroundColor)
      }
    }
    else {
      EmptyView()
    }
  }
}

// MARK: - 텍스트 토스트
private struct TextToast: View {
  private var text: String
  private var toastType: ToastType
  
  fileprivate init(
    text: String,
    toastType: ToastType
  ) {
    self.text = text
    self.toastType = toastType
  }
  
  fileprivate var body: some View {
    Text(text)
      .font(.b14)
      .foregroundColor(toastType.foregroundColor)
  }
}

// MARK: - 텍스트 + 아이콘 토스트
private struct TextWithIconToast: View {
  private var text: String
  private var toastType: ToastType
  
  fileprivate init(
    text: String,
    toastType: ToastType
  ) {
    self.text = text
    self.toastType = toastType
  }
  
  fileprivate var body: some View {
    HStack(spacing: 8) {
      toastType.iconImage?
        .frame(width: 18, height: 18)
      
      Text(text)
        .font(.b14)
        .foregroundColor(toastType.foregroundColor)
      
      Spacer()
    }
  }
}

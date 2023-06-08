//
//  BlurEffect.swift
//  DesignSystem
//
//  Created by 김영균 on 2023/06/08.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import SwiftUI

private struct VisualEffectView: UIViewRepresentable {
  var effect: UIVisualEffect?
  
  func makeUIView(context: UIViewRepresentableContext<Self>) -> UIVisualEffectView {
    UIVisualEffectView()
  }
  
  func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<Self>){
    uiView.effect = effect
  }
}

private struct BlurEffectModifier: ViewModifier {
  fileprivate init() {}
  
  fileprivate func body(content: Content) -> some View {
    content
      .overlay(VisualEffectView(effect: UIBlurEffect(style: .light)))
  }
}

public extension View {
  func blurEffect() -> some View {
    ModifiedContent(content: self, modifier: BlurEffectModifier())
  }
}

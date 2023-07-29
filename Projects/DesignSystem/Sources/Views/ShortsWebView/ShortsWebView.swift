//
//  ShortsWebView.swift
//  DesignSystem
//
//  Created by GREEN on 2023/04/28.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import SwiftUI
#if os(iOS)
import WebKit

struct UIWebView: UIViewRepresentable {
  let url: URL
  
  func makeUIView(context: Context) -> WKWebView {
    return WKWebView()
  }
  
  func updateUIView(_ uiView: WKWebView, context: Context) {
    let request = URLRequest(url: url)
    uiView.load(request)
  }
}

public struct ShortsWebView: View {
  public let webAddress: String
  
  public init(webAddress: String) {
    self.webAddress = webAddress
  }
  
  public var body: some View {
    UIWebView(url: URL(string: webAddress)!)
  }
}
#endif

//
//  ActivityView.swift
//  Common
//
//  Created by GREEN on 2023/04/05.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import SwiftUI

public struct ActivityView: UIViewControllerRepresentable {
  @Binding var isPresented: Bool
  var appLink: String
  public let applicationActivities: [UIActivity]? = nil
  
  public init(
    isPresented: Binding<Bool>,
    appLink: String
  ) {
    self._isPresented = isPresented
    self.appLink = appLink
  }
  
  public func makeUIViewController(context: Context) -> UIViewController {
    UIViewController()
  }
  
  public func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
    guard let url = URL(string: appLink) else { return }
    let shareItems = [url]
    
    let activityViewController = UIActivityViewController(
      activityItems: shareItems,
      applicationActivities: applicationActivities
    )
    
    if isPresented && uiViewController.presentedViewController == nil {
      uiViewController.present(activityViewController, animated: true)
    }
    
    activityViewController.completionWithItemsHandler = { (_, _, _, _) in
      isPresented = false
    }
  }
}

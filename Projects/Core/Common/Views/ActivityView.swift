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
  public let activityItems: [Any]
  public let applicationActivities: [UIActivity]? = nil
  
  public init(
    isPresented: Binding<Bool>,
    activityItems: [Any]
  ) {
    self._isPresented = isPresented
    self.activityItems = activityItems
  }
  
  public func makeUIViewController(context: Context) -> UIViewController {
    UIViewController()
  }
  
  public func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
    let activityViewController = UIActivityViewController(
      activityItems: activityItems,
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

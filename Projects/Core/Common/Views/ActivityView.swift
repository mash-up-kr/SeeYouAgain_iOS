//
//  ActivityView.swift
//  Common
//
//  Created by GREEN on 2023/04/05.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import SwiftUI

#if os(iOS)
public struct ActivityView: UIViewControllerRepresentable {
  @Binding var isPresented: Bool
  public let activityItems: [Any]
  public let applicationActivities: [UIActivity]? = nil
  public var completion: (() -> Void)?
  
  public init(
    isPresented: Binding<Bool>,
    activityItems: [Any],
    completion: (() -> Void)? = nil
  ) {
    self._isPresented = isPresented
    self.activityItems = activityItems
    self.completion = completion
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
      completion?()
    }
  }
}
#endif

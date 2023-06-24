//
//  LoadingWindow.swift
//  DesignSystem
//
//  Created by GREEN on 2023/06/23.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import SwiftUI
import UIKit

public class LoadingWindow: UIWindow {
  public static let shared = LoadingWindow(frame: UIScreen.main.bounds)

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented: please use LoadingWindow.shared")
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    let loadingViewController = UIHostingController(rootView: LoadingView())
    loadingViewController.view?.backgroundColor = .clear
    self.rootViewController = loadingViewController
    self.isHidden = true
  }

  func show() {
    self.isHidden = false
  }

  func hide() {
    self.isHidden = true
  }

  func toggle() {
    if self.isHidden {
      show()
    } else {
      hide()
    }
  }
}

public extension View {
  func loading(_ isLoading: Bool) -> Self {
    if isLoading {
      LoadingWindow.shared.show()
    } else {
      LoadingWindow.shared.hide()
    }
    return self
  }
}

//
//  UINavigationController+extensions.swift
//  App
//
//  Created by GREEN on 2023/04/05.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import UIKit

extension UINavigationController: UIGestureRecognizerDelegate {
  override open func viewDidLoad() {
    super.viewDidLoad()
    interactivePopGestureRecognizer?.delegate = self
  }

  public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
    return viewControllers.count > 1
  }
}

public func popToRoot() {
  let window = UIApplication.shared.connectedScenes
    .filter { $0.activationState == .foregroundActive }
    .map { $0 as? UIWindowScene }
    .compactMap { $0 }
    .first?.windows
    .filter { $0.isKeyWindow }
    .first

  let profile = window?.rootViewController?.children.first as? UINavigationController

  profile?.popToRootViewController(animated: true)
}

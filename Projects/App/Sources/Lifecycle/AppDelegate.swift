//
//  AppDelegate.swift
//  App
//
//  Created by GREEN on 2023/04/05.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import DesignSystem
import Foundation
import SwiftUI
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  
  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    self.window = UIWindow(frame: UIScreen.main.bounds)
    let appView = AppView(
      store: .init(
        initialState: .init(),
        reducer: appReducer,
        environment: .init()
      )
    )
    
    window?.rootViewController = UIHostingController(rootView: appView)
    window?.makeKeyAndVisible()
    setupLoadingWindow()
    
    return true
  }
  
  func setupLoadingWindow() {
    _ = LoadingWindow.shared
  }
}

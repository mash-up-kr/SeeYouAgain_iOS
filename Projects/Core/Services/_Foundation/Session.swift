//
//  Session.swift
//  Services
//
//  Created by 김영균 on 2023/05/04.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Alamofire
import Foundation

public final class Session {
  public static let shared = Session()
  
  public let AFSession: Alamofire.Session
  
  private init() {
    let configuration = URLSessionConfiguration.af.default
    configuration.timeoutIntervalForRequest = 10
    configuration.timeoutIntervalForResource = 10
    
    let logger = NetworkEventLogger()
    AFSession = Alamofire.Session(configuration: configuration, eventMonitors: [logger])
  }
}

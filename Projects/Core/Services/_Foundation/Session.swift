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
  
  public let session: Alamofire.Session
  
  private init() {
    let configuration = URLSessionConfiguration.af.default
    let logger = NetworkEventLogger()
    session = Alamofire.Session(configuration: configuration, eventMonitors: [logger])
  }
}

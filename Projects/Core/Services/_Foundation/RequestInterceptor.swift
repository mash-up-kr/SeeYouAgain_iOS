//
//  RequestInterceptor.swift
//  Services
//
//  Created by 김영균 on 2023/06/21.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Alamofire
import Foundation

final class CustomRequestInterceptor: RequestInterceptor {
  func adapt(
    _ urlRequest: URLRequest,
    for session: Alamofire.Session,
    completion: @escaping (Result<URLRequest, Error>
    ) -> Void) {
    var urlRequest = urlRequest
    urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
    if let uuid = UserDefaults.standard.string(forKey: "userID") {
      urlRequest.setValue("Bearer \(uuid)", forHTTPHeaderField: "Authorization")
    }
    completion(.success(urlRequest))
  }
}

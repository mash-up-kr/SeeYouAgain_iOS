//
//  NetworkEventLogger.swift
//  Services
//
//  Created by 김영균 on 2023/05/03.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Alamofire
import Foundation

final class NetworkEventLogger: EventMonitor {
  let queue: DispatchQueue = DispatchQueue(label: "Network Logger")
  
  func requestDidFinish(_ request: Request) {
    debugPrint("=============== 📍 Network Request Log 📍 ===============")
    debugPrint("  ✅ [URL] : \(request.request?.url?.absoluteString ?? "")")
    debugPrint("  ✅ [Method] : \(request.request?.httpMethod ?? "")")
    debugPrint("  ✅ [Headers] : \(request.request?.allHTTPHeaderFields ?? [:])")
    if let body = request.request?.httpBody?.toPrettyPrintedString {
      debugPrint("  ✅ [Body]: \(body)")
    } else {
      debugPrint("  ✅ [Body]: Body가 없습니다.")
    }
    debugPrint("=========================================================")
  }
  
  func request<Value>(
    _ request: DataRequest,
    didParseResponse response: DataResponse<Value, AFError>
  ) {
    debugPrint("=============== 📍 Network Response Log 📍 ==============")
    
    switch response.result {
    case .success:
      debugPrint("  ✅ [Status Code] : \(response.response?.statusCode ?? 0)")
    case .failure:
      debugPrint("  ❎ 요청에 실패했습니다.")
    }
    
    if let statusCode = response.response?.statusCode {
      switch statusCode {
      case 400..<500:
        debugPrint("  ❎ 클라이언트 오류")
      case 500..<600:
        debugPrint("  ❎ 서버 오류")
      default:
        break
      }
    }
    
    if let response = response.data?.toPrettyPrintedString {
      debugPrint("  ✅ [Response] : \(response)")
    }
    debugPrint("=========================================================")
  }
  
  func request(
    _ request: Request,
    didFailTask task: URLSessionTask,
    earlyWithError error: AFError
  ) {
    debugPrint("  ❎ Did Fail URLSessionTask")
  }
  
  func request(
    _ request: Request,
    didFailToCreateURLRequestWithError error: AFError
  ) {
    debugPrint("  ❎ Did Fail To Create URLRequest With Error")
  }
  
  func requestDidCancel(_ request: Request) {
    debugPrint("  ❎ Request Did Cancel")
  }
}

fileprivate extension Data {
  var toPrettyPrintedString: String? {
    guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
      let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
      let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
    else {
      return nil
    }
    return prettyPrintedString as String
  }
}

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
    print("=============== 📍 Network Request Log 📍 ===============\n")
    print("  ✅ [URL] : \(request.request?.url?.absoluteString ?? "")\n")
    print("  ✅ [Method] : \(request.request?.httpMethod ?? "")\n")
    print("  ✅ [Headers] : \(request.request?.allHTTPHeaderFields ?? [:])\n")
    print("  ✅ [Body] : \n")
    if let body = request.request?.httpBody?.toPrettyPrintedString {
      print("\(body)\n")
    } else {
      print("  Body가 없습니다.\n")
    }
    print("=========================================================\n")
  }
  
  func request<Value>(
    _ request: DataRequest,
    didParseResponse response:
    DataResponse<Value, AFError>
  ) {
    print("=============== 📍 Network Response Log 📍 =============\n")
    
    switch response.result {
    case .success:
      print("  ✅ [Status Code] : \(response.response?.statusCode ?? 0) \n")
    case .failure:
      print("  ❎ 요청에 실패했습니다.\n")
    }
    
    if let statusCode = response.response?.statusCode {
      switch statusCode {
      case 400..<500:
        print("  ❎ 클라이언트 오류\n")
      case 500..<600:
        print("  ❎ 서버 오류\n")
      default:
        break
      }
    }
    
    if let response = response.data?.toPrettyPrintedString {
      print("  ✅ [Response] : \(response) \n")
    }
    print("========================================================\n")
  }
  
  func request(
    _ request: Request,
    didFailTask task: URLSessionTask,
    earlyWithError error: AFError
  ) {
    print("  ❎ Did Fail URLSessionTask\n")
  }
  
  func request(
    _ request: Request,
    didFailToCreateURLRequestWithError error: AFError
  ) {
    print("  ❎ Did Fail To Create URLRequest With Error\n")
  }
  
  func requestDidCancel(_ request: Request) {
    print("  ❎ Request Did Cancel\n")
  }
}

fileprivate extension Data {
  var toPrettyPrintedString: String? {
    guard
      let object = try? JSONSerialization.jsonObject(with: self, options: []),
      let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
      let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
    else {
      return nil
    }
    return prettyPrintedString as String
  }
}

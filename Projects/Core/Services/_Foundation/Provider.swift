//
//  Provider.swift
//  Services
//
//  Created by 김영균 on 2023/05/03.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Alamofire
import Combine
import Foundation

public struct Provider<Target: TargetType> {
  private let session: Alamofire.Session
  private let stubBehavior: StubBehavior
  
  public init(
    session: Alamofire.Session = Session.shared.session,
    stubBehavior: StubBehavior = .never
  ) {
    self.session = session
    self.stubBehavior = stubBehavior
  }
  
  public func request<T: Decodable>(_ target: TargetType, type: T.Type) -> Future<T, Error> {
    switch stubBehavior {
    case .never:
      return requestObject(target, type: type)
    case .immediate:
      return requestStub(target, type: type)
    }
  }
}

// MARK: Private Request Methods
private extension Provider {
  func requestObject<T: Decodable>(_ target: TargetType, type: T.Type) -> Future<T, Error> {
    return Future { promise in
      self.session.request(target).responseData { response in
        switch response.result {
        case .success(let value):
          guard let statusCode = response.response?.statusCode else { return }
          let isSuccessful = (200..<300).contains(statusCode)
          
          if isSuccessful {
            do {
              let data = try JSONDecoder().decode(ResponseDTO.ExistData<T>.self, from: value)
              promise(.success(data.data))
            } catch {
              let error = ProviderError(
                code: .failedDecode,
                userInfo: ["target" : target],
                response: response
              )
              promise(.failure(error))
            }
          } else {
            let error = ProviderError(
              code: .isNotSuccessful,
              userInfo: ["target": target],
              response: response
            )
            promise(.failure(error))
          }
          
        case let .failure(underlyingError):
          let error = ProviderError(
            code: .failedRequest,
            userInfo: ["target": target],
            underlying: underlyingError,
            response: response
          )
          promise(.failure(error))
        }
      }
    }
  }
  
  func requestStub<T: Decodable>(_ target: TargetType, type: T.Type) -> Future<T, Error> {
    return Future { promise in
      switch stubBehavior {
      case .never:
        break
      case .immediate:
        do {
          let data = try JSONDecoder().decode(T.self, from: target.sampleData)
          promise(.success(data))
        } catch let error {
          promise(.failure(error))
        }
      }
    }
  }
}

public enum StubBehavior {
  /// Do not stub.
  case never
  /// Return a response immediately.
  case immediate
}

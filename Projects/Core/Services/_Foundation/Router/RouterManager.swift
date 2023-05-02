//
//  RouterManager.swift
//  Services
//
//  Created by GREEN on 2023/04/05.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Alamofire
import Combine
import Common
import Foundation

public struct RouterManager<T: Router> {
  private let alamorefireSession: Session
  private let stubBehavior: StubBehavior
  private let interceptor: Interceptor?
  
  public init(
    alamofireSession: Session = .default,
    interceptor: Interceptor? = nil,
    stubBehavior: StubBehavior = .never
  ) {
    self.alamorefireSession = alamofireSession
    self.stubBehavior = stubBehavior
    self.interceptor = interceptor
  }
  
  public func request(router: T) -> Future<Data, Error> {
    switch stubBehavior {
    case .never:
      return sendRequest(router: router)
    case .delayed, .immediate:
      return stubRequest(router: router)
    }
  }
}

public enum StubBehavior {
  // stub을 사용하지 않습니다.
  case never
  
  // 즉시 stub을 return합니다.
  case immediate

  // 딜레이 이후 stub을 return합니다.
  case delayed(seconds: TimeInterval)
}

public struct RouterManagerError: SeeYouAgainError {
  public var userInfo: [String: Any]?
  public var code: Code
  public var underlying: Error?
  public var errorBody: BasicResponseDTO.Common?

  public enum Code: Int {
    case failedRequest = 0
    case isNotSuccessful = 1
  }
  
  public init(
    code: RouterManagerError.Code,
    userInfo: [String: Any]? = nil,
    underlying: Error? = nil,
    response: AFDataResponse<Data>? = nil
  ) {
    self.code = code
    self.userInfo = userInfo
    self.underlying = underlying
    self.userInfo?["response"] = response

    if let data = response?.data {
      self.errorBody = try? JSONDecoder().decode(BasicResponseDTO.Common.self, from: data)
    }
  }
}

public extension SeeYouAgainError {
  func findRouterManagerError() -> RouterManagerError? {
    var routerManagerError: RouterManagerError?
    var targetError: (any SeeYouAgainError)? = self
    
    while routerManagerError == nil {
      guard let _targetError = targetError else { return nil }
      
      if let error = _targetError as? RouterManagerError {
        routerManagerError = error
      } else {
        targetError = _targetError.underlying as? (any SeeYouAgainError)
      }
    }
    
    return routerManagerError
  }
}

fileprivate extension RouterManager {
  // alamofire 를 통해 요청을 보냅니다.
  func sendRequest(router: T) -> Future<Data, Error> {
    return Future<Data, Error> { promise in
      let dataRequest: DataRequest = makeDataRequest(router: router)
      
      dataRequest
        .responseData { response in
          switch response.result {
          case .success:
            guard let statusCode = response.response?.statusCode else { return }
            let isSuccessful = (200..<300).contains(statusCode)
            
            if isSuccessful {
              guard let data = response.data else { return }
              promise(.success(data))
            } else {
              let error = RouterManagerError(
                code: .isNotSuccessful,
                userInfo: ["router": router],
                response: response
              )
              promise(.failure(error))
            }
            
          case let .failure(underlyingError):
            let error = RouterManagerError(
              code: .failedRequest,
              userInfo: ["router": router],
              underlying: underlyingError,
              response: response
            )
            promise(.failure(error))
          }
        }
    }
  }
  
  // stub을 return하는 요청을 보냅니다.
  func stubRequest(router: T) -> Future<Data, Error> {
    return Future<Data, Error> { promise in
      switch stubBehavior {
      case .immediate:
        promise(.success(router.sampleData))
      case .delayed(let delay):
        let killTimeOffset = Int64(CDouble(delay) * CDouble(NSEC_PER_SEC))
        let killTime = DispatchTime.now() + Double(killTimeOffset) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: killTime) {
          promise(.success(router.sampleData))
        }
      case .never:
        break
      }
    }
  }
  
  // task에 따라 적절한 dataRequest를 생성합니다.
  func makeDataRequest(router: Router) -> DataRequest {
    switch router.task {
    case .requestPlain:
      return self.alamorefireSession.request(
        "\(router.baseURL)\(router.path)",
        method: router.method,
        headers: HTTPHeaders(headers: router.headers),
        interceptor: interceptor
      )
      
    case let .requestJSONEncodable(parameters):
      let encodable = AnyEncodable(parameters)
      
      return self.alamorefireSession.request(
        "\(router.baseURL)\(router.path)",
        method: router.method,
        parameters: encodable,
        encoder: JSONParameterEncoder.default,
        headers: HTTPHeaders(headers: router.headers),
        interceptor: interceptor
      )
      
    case let .requestCustomJSONEncodable(parameters, encoder):
      let encodable = AnyEncodable(parameters)
      
      return self.alamorefireSession.request(
        "\(router.baseURL)\(router.path)",
        method: router.method,
        parameters: encodable,
        encoder: .json(encoder: encoder),
        headers: HTTPHeaders(headers: router.headers),
        interceptor: interceptor
      )
      
    case let .requestParameters(parameters, encoding):
      return self.alamorefireSession.request(
        "\(router.baseURL)\(router.path)",
        method: router.method,
        parameters: parameters,
        encoding: encoding,
        headers: HTTPHeaders(headers: router.headers),
        interceptor: interceptor
      )
      
    }
  }
}

fileprivate extension HTTPHeaders {
  init?(headers: [String: String]?) {
    guard let headers = headers else {
      return nil
    }
    
    self.init(headers)
  }
}

fileprivate struct AnyEncodable: Encodable {
  private let encodable: Encodable
  
  public init(_ encodable: Encodable) {
    self.encodable = encodable
  }
  
  func encode(to encoder: Encoder) throws {
    try encodable.encode(to: encoder)
  }
}

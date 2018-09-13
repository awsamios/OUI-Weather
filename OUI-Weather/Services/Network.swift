//
//  Network.swift
//  OUI-Weather
//
//  Created by Samira on 06/07/2018.
//  Copyright © 2018 Bands. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import PromiseKit

let apiId = "9e878267a7354c1d0315f3c64b9a4c89"
let apiHost = "http://api.openweathermap.org"


/// The dispatcher is responsible to execute a Request
/// by calling the Alamofire
/// As output for a Request it should provide a Promise with the result.
public protocol Dispatcher {
  
  /// Configure the dispatcher with an environment
  ///
  /// - Parameter environment: environment configuration
  init(environment: Environment)
  
  
  /// This function execute the request and provide a Promise
  /// with the response.
  ///
  /// - Parameter request: request to execute
  /// - Returns: promise
  func executeJSON(request: Request) throws -> Promise<JSON>
  
  func execute(request: Request) throws -> Promise<Data>
}


public enum NetworkErrors: Error {
  case badInput
  case noData
}

public class NetworkDispatcher: Dispatcher {
  
  var alamofireManager: Alamofire.SessionManager
  
  private var environment: Environment
  
  required public init(environment: Environment) {
    self.environment = environment
    let configuration = URLSessionConfiguration.default
    configuration.requestCachePolicy = environment.cachePolicy
    self.alamofireManager = Alamofire.SessionManager(configuration: configuration)
    
  }
  
  public func executeJSON(request: Request) throws -> Promise<JSON> {
    
    return Promise<JSON> { resolver in
      
      do {
        try self.execute(request: request).done { data in
          resolver.fulfill(JSON(data))
          }
          .catch { error in
            resolver.reject(error)
        }
      }
      catch {
        resolver.reject(error)
      }
    }
  }
  
  public func execute(request: Request) throws -> Promise<Data> {
    return Promise<Data> { resolver in
      guard let url =  try self.prepareRequest(for: request).url else {
        return
      }
      
      Alamofire.request(url, method: request.method)
        .validate()
        .responseData { response in
          switch response.result {
          case .success(let value):
            resolver.fulfill(value)
            
          case .failure:
            guard let error = response.error else { return }
            resolver.reject(error)
          }
      }
    }
  }
  
  func prepareRequest(for request: Request) throws -> URLRequest {
    // Compose the url
    let fullUrl = "\(environment.host)/\(request.path)"
    var urlRequest = URLRequest(url: URL(string: fullUrl)!)
    
    // Working with parameters
    switch request.parameters {
    case .body(let params):
      // Parameters are part of the body
      if let params = params as? [String: String] { // just to simplify
        urlRequest.httpBody = try JSONSerialization.data(withJSONObject: params, options: .init(rawValue: 0))
      } else {
        throw NetworkErrors.badInput
      }
    case .url(let params):
      // Parameters are part of the url
      if let params = params as? [String: String] { // just to simplify
        let query_params = params.map({ (element) -> URLQueryItem in
          return URLQueryItem(name: element.key, value: element.value)
        })
        
        guard var components = URLComponents(string: fullUrl) else {
          throw NetworkErrors.badInput
        }
        
        components.queryItems = query_params
        urlRequest.url = components.url
      } else {
        throw NetworkErrors.badInput
      }
    }
    
    // Add headers from enviornment and request
    environment.headers.forEach { urlRequest.addValue($0.value as! String, forHTTPHeaderField: $0.key) }
    request.headers?.forEach { urlRequest.addValue($0.value as! String, forHTTPHeaderField: $0.key) }
    
    // Setup HTTP method
    urlRequest.httpMethod = request.method.rawValue
    
    return urlRequest
  }
}

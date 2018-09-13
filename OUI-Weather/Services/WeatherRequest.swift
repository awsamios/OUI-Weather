//
//  WeatherRequest.swift
//  OUI-Weather
//
//  Created by Samira on 12/07/2018.
//  Copyright © 2018 Bands. All rights reserved.
//

import Foundation
import Alamofire

enum WeatherCases {
  // MARK: Use cases
  
  enum FetchWeather {
    struct Request {
      var value: Any?
      var requestType: WeatherRequestType?
    }
    
    struct Response {
      var weatherList: WeatherList
    }
    
    struct ViewModel {

      struct DisplayedWeather {
        var minTemp: String
        var maxTemp: String
        var description: String
        var iconUrl: URL?
        var time: String
        var fullDate: String
        var readableDay: String
        var cityName: String
        
        init(minTemp: String = "", maxTemp: String = "", description: String = "", iconUrl: URL? = nil, time: String = "", fullDate: String = "", readableDay: String = "", cityName: String = "") {
          self.minTemp = minTemp
          self.maxTemp = maxTemp
          self.description = description
          self.time = time
          self.readableDay = readableDay
          self.cityName = cityName
          self.iconUrl = iconUrl
          self.fullDate = fullDate
        }
      }
      
      var displayedWeatherList: [DisplayedWeather]
      var currentDayWeather: (DisplayedWeather, [DisplayedWeather])
    }
  }
}

public enum WeatherRequests: Request {
  case fetchIconByName(String)
  case fetchWeatherByCityName(String)
  case fetchWeatherById(String)
  case fetchWeatherByCoordinates(String) //TODO coordinates
  
  
  public var path: String {
    switch self {
    case .fetchWeatherByCityName(_), .fetchWeatherById(_), .fetchWeatherByCoordinates(_) :
      return "data/2.5/forecast"
      
    case .fetchIconByName(let iconName):
      return "/img/w/\(iconName).png"
    }
  }
  
  public var method: HTTPMethod {
    switch self {
    case .fetchWeatherByCityName(_), .fetchWeatherById(_), .fetchWeatherByCoordinates(_), .fetchIconByName(_):
      return .get
    }
  }
  
  private var defaultParameters: [String : Any] {
    return ["units": "metric", "lang": "fr", "appid": apiId]
  }
  
  public var parameters: RequestParams {
    var params = self.defaultParameters
    
    switch self {
    case .fetchWeatherByCityName(let cityName):
      params["q"] = cityName
      return .url(params)
      
    case .fetchWeatherById(let cityId):
      params["id"] = cityId
      
    case .fetchWeatherByCoordinates(let _coordinates):
      params["lat"] = ""
      params["lon"] = ""
      
    default:
      break
      
    }
    
    return .url(params)
  }
  
  public var headers: [String : Any]? {
    switch self {
    default:
      return nil
    }
  }
}

public protocol Request {
  
  /// Relative path of the endpoint we want to call
  var path: String { get }
  
  /// This define the HTTP method we should use to perform the call
  /// We have defined it inside an String based enum called `HTTPMethod`
  /// just for clarity
  var method: HTTPMethod { get }
  
  /// These are the parameters we need to send along with the call.
  /// Params can be passed into the body or along with the URL
  var parameters: RequestParams { get }
  
  /// You may also define a list of headers to pass along with each request.
  var headers: [String: Any]? { get }
}

/// Define parameters to pass along with the request and how
/// they are encapsulated into the http request itself.
///
/// - body: part of the body stream
/// - url: as url parameters
public enum RequestParams {
  case body(_ : [String: Any]?)
  case url(_ : [String: Any]?)
}


/// Environment is a struct which encapsulate all the informations
/// we need to perform a setup of our Networking Layer.
/// In this example we just define the name of the environment (ie. Production,
/// Test Environment #1 and so on) and the base url to complete requests.
/// You may also want to include any SSL certificate or wethever you need.
public struct Environment {
  
  /// Base URL of the environment
  public var host: String
  
  /// This is the list of common headers which will be part of each Request
  /// Some headers value maybe overwritten by Request's own headers
  public var headers: [String: Any] = [:]
  
  /// Cache policy
  public var cachePolicy: URLRequest.CachePolicy = .reloadIgnoringLocalAndRemoteCacheData
  
  /// Initialize a new Environment
  ///
  /// - Parameters:
  ///   - host: base url
  public init(_ host: String) {
    self.host = host
  }
}

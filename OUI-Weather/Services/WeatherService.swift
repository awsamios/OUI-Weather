//
//  WeatherService.swift
//  OUI-Weather
//
//  Created by Samira on 07/07/2018.
//  Copyright © 2018 Bands. All rights reserved.
//

import Foundation
import PromiseKit
import SwiftyJSON

enum WeatherRequestType {
  case id, name, coordinates, iconImage
}

protocol WeatherProvider {
  
  /// Request to execute
  var request: Request? { get }
  
  /// Execute the retrieving weather request in passed dispatcher
  ///
  /// - Parameter dispatcher: dispatcher
  /// - Returns: a promise
  func getWeatherList(in dispatcher: Dispatcher) -> Promise<WeatherList>?
}

class WeatherService: WeatherProvider {
  
  var value: Any?
  var requestType: WeatherRequestType?
  
  init(value: Any?, requestType: WeatherRequestType?) {
    self.requestType = requestType
    self.value = value
  }
  
  
  var request: Request? {
    guard let type = self.requestType else {
      return nil
    }
    
    switch type {
    case .id:
      guard let id = self.value as? String else { return nil }
      return WeatherRequests.fetchWeatherById(id)
      
    case .name:
      guard let name = self.value as? String else { return nil }
      return WeatherRequests.fetchWeatherByCityName(name)
      
    case .coordinates:
      guard let coordinates = self.value as? String else { return nil }
      return WeatherRequests.fetchWeatherByCoordinates(coordinates)
      
    case .iconImage:
      guard let iconName = self.value as? String else { return nil }
      return WeatherRequests.fetchIconByName(iconName)
    }
  }
  
  func getWeatherList(in dispatcher: Dispatcher) -> Promise<WeatherList>? {
    guard let request = self.request else { return nil }
    
    return Promise<WeatherList> { resolver in
      do {
        try dispatcher.executeJSON(request: request).done { json in
          // parse the json
          guard let weatherList = WeatherList(json) else {
            return
          }
          
          resolver.fulfill(weatherList)
          
          }.catch { error in
            resolver.reject(error)
        }
      }
      catch {
        resolver.reject(error)
      }
    }
  }
}

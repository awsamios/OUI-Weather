//
//  WeatherWorker.swift
//  OUI-Weather
//
//  Created by Samira on 10/07/2018.
//  Copyright © 2018 Bands. All rights reserved.
//

import Foundation
import PromiseKit

class WeatherWorker {
  var weatherService: WeatherProvider?
  
  init(_ service: WeatherProvider) {
    self.weatherService = service
  }
  
  func fetchWeatherList() -> Promise<WeatherList>? {
    
    let environment = Environment(apiHost)
    let dispatcher = NetworkDispatcher(environment: environment)
    return self.weatherService?.getWeatherList(in: dispatcher)
  }
}



//
//  WeatherInteractor.swift
//  OUI-Weather
//
//  Created by Samira on 10/07/2018.
//  Copyright © 2018 Bands. All rights reserved.
//

import Foundation

protocol WeatherBusinessLogic {
  func fetchForecastWeather(request: WeatherCases.FetchWeather.Request)
}

protocol WeatherListDataStore {
  var weatherList: WeatherList? { get }
}

class WeatherInteractor: WeatherBusinessLogic, WeatherListDataStore {
  var weatherList: WeatherList?
  var presenter: WeatherPresentationLogic?
  var worker: WeatherWorker?
  
  func fetchForecastWeather(request: WeatherCases.FetchWeather.Request) {
    
    let service = WeatherService(value: request.value, requestType: request.requestType)
    self.worker = WeatherWorker(service)
    
    self.presenter?.showLoader()
    self.worker?.fetchWeatherList()?.done({ weatherList in
            self.presenter?.hideLoader()
      self.weatherList = weatherList
      let response = WeatherCases.FetchWeather.Response(weatherList: weatherList)
      self.presenter?.presentWeatherList(response: response)

    }).catch { error in
        self.presenter?.hideLoader()
    }
  }
}

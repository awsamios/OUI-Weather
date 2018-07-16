//
//  WeatherPresenter.swift
//  OUI-Weather
//
//  Created by Samira on 10/07/2018.
//  Copyright © 2018 Bands. All rights reserved.
//

import Foundation

protocol Indicatable {
  func showLoader()
  func hideLoader()
}

protocol WeatherPresentationLogic: Indicatable {
  func presentWeatherList(response: WeatherCases.FetchWeather.Response)
}

class WeatherPresenter: WeatherPresentationLogic {
  
  weak var viewController: WeatherDisplayLogic?
  
  // MARK: - show weatherList
  
  ///
  func presentWeatherList(response: WeatherCases.FetchWeather.Response) {
    
    let weatherList = response.weatherList
    let todayWeather = weatherList.groupedWeather?.first
 
    let filteredWeatherList = self.filterWeatherList(
      weatherList: weatherList, referenceDate: todayWeather?.value.first?.fullDate ?? Date())
  .sorted {
        ($0.0?.shortDate ?? Date()) < ($1.0?.shortDate ?? Date())
    }
    
    // the whole days
    let displayedWeatherList = self.buildDisplayeWeatherList(filteredWeatherList, cityName: weatherList.city?.name)
    
    let todayDisplayedDay = self.buildCurrentDayWeather(weatherList.groupedWeather?.first?.value, cityName: weatherList.city?.name)
    
    let viewModel = WeatherCases.FetchWeather.ViewModel(
      displayedWeatherList: displayedWeatherList,
      currentDayWeather: todayDisplayedDay)
    
    viewController?.displayFetchedWeather(viewModel: viewModel)
  }
  
  func showLoader() {
    self.viewController?.showLoader()
  }
  
  func hideLoader() {
    self.viewController?.hideLoader()
  }
  
  func buildCurrentDayWeather(_ currentWeatherList: [Weather]?, cityName: String?) -> (WeatherCases.FetchWeather.ViewModel.DisplayedWeather,
    [WeatherCases.FetchWeather.ViewModel.DisplayedWeather]) {
      
      let nowDisplayedData =  self.buildDisplayedDayWeather(currentWeatherList?.first, cityName: cityName, minTemperture: 0) ?? WeatherCases.FetchWeather.ViewModel.DisplayedWeather()
      
      let todayList = currentWeatherList?.compactMap {
        return self.buildDisplayedDayWeather($0, cityName: cityName, minTemperture: 0)
      }
      
      return(nowDisplayedData, todayList ?? [])
  }
  
  private func filterWeatherList(weatherList: WeatherList, referenceDate: Date) -> [(Weather?, Double?)] {
    // get the next days weather for the same time of now
    let filteredWeatherList = weatherList.groupedWeather?.compactMap { currentGroup -> (Weather?, Double?) in
      
      let filteredWeather = currentGroup.value.filter { item in
        Calendar.current.component(.hour, from: item.fullDate) == Calendar.current.component(.hour, from: (referenceDate))
        }.first
      
      let minTemperture = currentGroup.value.min {
        guard let temp1 = $0.main?.minTemperture,
          let temp2 = $1.main?.minTemperture else { return false }
        return temp1 < temp2
        }?.main?.minTemperture
      
      return(filteredWeather, minTemperture)
      
    }
    
    return filteredWeatherList ?? []
  }
  
  /// Transforms the given weather list to displayed data list
  private func buildDisplayeWeatherList(_ list: [(Weather?, Double?)]?, cityName: String?) -> [WeatherCases.FetchWeather.ViewModel.DisplayedWeather] {
    
    var displayedList: [WeatherCases.FetchWeather.ViewModel.DisplayedWeather] = []
    
    list?.forEach {
      if let item = self.buildDisplayedDayWeather($0.0, cityName: cityName, minTemperture: $0.1) {
        displayedList.append(item)
      }
    }
    
    return displayedList
  }
  
  /// Transforms the given weather to displayed data
  private func buildDisplayedDayWeather(_ weather: Weather?, cityName: String?, minTemperture: Double?) -> WeatherCases.FetchWeather.ViewModel.DisplayedWeather? {
    
    guard let mintemp = minTemperture?.rounded(), let maxTemp = weather?.main?.maxTemperture.rounded() else {
      return nil
    }
    
    
    return WeatherCases.FetchWeather.ViewModel.DisplayedWeather(
      minTemp: "\(String(describing: mintemp))°",
      maxTemp: "\(String(describing:maxTemp))°",
      description: weather?.weatherDetails?.description ?? "",
      iconUrl: URL(string: "http://openweathermap.org/img/w/\(weather?.weatherDetails?.icon ?? "").png"),
      time: "\(Calendar.current.component(.hour, from: weather?.fullDate ?? Date()))h",
      fullDate: weather?.fullDateString ?? "",
      readableDay: weather?.fullDate.dayOfWeek() ?? "",
      cityName: cityName ?? "")
    
  }
  
  
}

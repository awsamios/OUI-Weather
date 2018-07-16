//
//  Weather.swift
//  OUI-Weather
//
//  Created by Samira on 06/07/2018.
//  Copyright © 2018 Bands. All rights reserved.
//

import Foundation
import SwiftyJSON
// example
//"weather":[{"id":804,"main":"Clouds","description":"overcast clouds","icon":"04d"}],

struct WeatherList {
  
  var list: [Weather]
  
  var city: City?
  var groupedWeather: Dictionary<Date, [Weather]>? // String : Date
  
  init?(_ json: JSON?) {
    guard let json = json else { return nil }
    
    guard let jsonList = json["list"].array else {
      return nil
    }
    
    self.city = City(json["city"])
    self.list = jsonList.compactMap { Weather($0) }

    self.groupedWeather = Dictionary(grouping: self.list) {
      $0.shortDate
    }
  }
}

struct Weather: Hashable {
  
  var main: WeatherMain?
  var shortDate: Date //Data/time of calculation, UTC, ex 2018-07-12 06:00:00
  var fullDateString: String
  var fullDate: Date
  var forecastedTime: String? // Time of data forecasted, unix, UTC
  var weatherDetails: WeatherDetails?
  
  var hashValue: Int {
    return self.shortDate.hashValue
  }
  
  init?(_ json: JSON?) {
    guard let json = json else { return nil }
    self.forecastedTime = json["dt"].string
    self.main = WeatherMain(json["main"])
    self.weatherDetails = WeatherDetails(json["weather"].array?.first)
    
    guard let jsonDate = json["dt_txt"].string else { return nil }
    self.fullDateString = jsonDate
    self.shortDate = jsonDate.isoDate?.shortDate ?? Date()
    self.fullDate = jsonDate.isoDate ?? Date()
  }
  
  static func == (lhs: Weather, rhs: Weather) -> Bool {
    return lhs.shortDate == rhs.shortDate
  }
}

struct WeatherMain {
  
  var minTemperture: Double
  var maxTemperture: Double
  var temperture: Double
  var pressure: Double
  var seaLevel: Double
  var groundLevel: Double
  var humidity: Double
  
  init?(_ json: JSON?) {
    guard let json = json else { return nil }
    self.minTemperture = json["temp_min"].double ?? 0
    self.maxTemperture = json["temp_max"].double  ?? 0
    self.temperture = json["temp"].double ?? 0
    self.pressure = json["pressure"].double ?? 0
    self.seaLevel = json["sea_level"].double ?? 0
    self.groundLevel = json["grnd_level"].double ?? 0
    self.humidity = json["humidity"].double ?? 0
  }
}

struct City {
  var identifier: Double?
  var name: String
  // var coordinates: [String: Double]
  var country: String?
  var population: String?
  
  init?(_ json: JSON?) {
    guard let json = json else { return nil }
    
    self.identifier = json["id"].double
    self.name = json["name"].string ?? ""
    //  self.coordinates = json["coord"].dictionary
    self.country = json["country"].string
    self.population = json["population"].string
  }
}

struct WeatherDetails {
  //  "id": 800,
  //  "main": "Clear",
  //  "description": "ciel dégagé",
  //  "icon": "01d"
  
  var identifier: Int?
  var main: String?
  var description: String
  var icon: String
  
  init?(_ value: JSON?) {
    guard let json = value else { return nil }
    
    self.identifier = json["id"].int
    self.main = json["main"].string
    self.description = json["description"].string ?? ""
    self.icon = json["icon"].string ?? ""
  }
}

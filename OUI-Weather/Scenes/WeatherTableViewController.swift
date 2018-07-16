//
//  WeatherTableViewController.swift
//  OUI-Weather
//
//  Created by Samira on 05/07/2018.
//  Copyright © 2018 Bands. All rights reserved.
//

import UIKit
import JGProgressHUD

protocol WeatherDisplayLogic: class {
  func displayFetchedWeather(viewModel: WeatherCases.FetchWeather.ViewModel?)
  func showLoader()
  func hideLoader()
}

class WeatherTableViewController: UITableViewController {
  
  // MARK: - Attributes
  var weatherService: WeatherProvider?
  var interactor: WeatherBusinessLogic?
  
  var cityName: String?
  
  var displayedWeatherList: [WeatherCases.FetchWeather.ViewModel.DisplayedWeather] = []
  var displayedTodayWeather: (WeatherCases.FetchWeather.ViewModel.DisplayedWeather, [WeatherCases.FetchWeather.ViewModel.DisplayedWeather])?
  var hudIndicator: JGProgressHUD?
  
  // MARK: - life cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    self.setup()
    let request = WeatherCases.FetchWeather.Request(value: self.cityName, requestType: .name)
    self.fetchWeather(request: request)
  }
  
  private func setup() {
    let viewController = self
    
    let interactor = WeatherInteractor()
    let presenter = WeatherPresenter()
    presenter.viewController = viewController
    interactor.presenter = presenter
    viewController.interactor = interactor
    
  }
  
  func fetchWeather(request: WeatherCases.FetchWeather.Request) {
    self.interactor?.fetchForecastWeather(request: request)
  }
  
  // MARK: - Table view data source
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.displayedWeatherList.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "dayReuseIdentifier", for: indexPath) as? DayWeatherTableViewCell ?? DayWeatherTableViewCell()
    
    let currentWeather = self.displayedWeatherList[indexPath.row]
    
    cell.configure(maxTemp: currentWeather.maxTemp, minTemp: currentWeather.minTemp, day: currentWeather.readableDay, iconUrl: currentWeather.iconUrl)
    
    return cell
    
  }
  
  func updateView() {
    
    if let header = self.tableView.tableHeaderView as? CityView, let data = self.displayedTodayWeather?.0 {
      
      header.delegate = self
      header.configure(
        name: data.cityName, desc: data.description, date: data.fullDate, temp: data.maxTemp, iconUrl: data.iconUrl)
      
      header.tableView.reloadData()
    }
    
    self.tableView.reloadData()
    
  }
}

// MARK: - Weather Display Logic

extension WeatherTableViewController: WeatherDisplayLogic {
  func displayFetchedWeather(viewModel: WeatherCases.FetchWeather.ViewModel?) {
    
    self.displayedTodayWeather = viewModel?.currentDayWeather
    self.displayedWeatherList = viewModel?.displayedWeatherList ?? []
    self.updateView()
  }
  
  func showLoader() {
    self.hudIndicator = JGProgressHUD(style: .light)
    self.hudIndicator?.show(in: self.view)
  }
  
  func hideLoader() {
    self.hudIndicator?.dismiss(afterDelay: 3.0)
  }
}


extension WeatherTableViewController: WeatherDelegate {
  func numberOfItemsInSection() -> Int {
    return self.displayedTodayWeather?.1.count ?? 0
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCellIdentifier", for: indexPath) as? TimeWeatherCollectionViewCell ?? TimeWeatherCollectionViewCell()
    
    let item = self.displayedTodayWeather?.1[indexPath.row]
    cell.configure(hour: item?.time, temp: item?.maxTemp)
    
    return cell
  }
}


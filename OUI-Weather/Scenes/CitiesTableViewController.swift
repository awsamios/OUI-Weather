//
//  CitiesTableViewController.swift
//  OUI-Weather
//
//  Created by Samira on 16/07/2018.
//  Copyright © 2018 Bands. All rights reserved.
//

import UIKit

class CitiesTableViewController: UITableViewController {
  
  let cities = ["Paris", "Puteaux", "Courbevoie", "Lyon", "Lille"]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = "Cities" // should be in localizable.strings
  }
  
  // MARK: - Table view data source
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // #warning Incomplete implementation, return the number of rows
    return self.cities.count
  }
  
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
    cell.textLabel?.text = self.cities[indexPath.row]
    return cell
  }
  
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let controller = segue.destination as? WeatherTableViewController, let cell = sender as? UITableViewCell {
      controller.cityName = cell.textLabel?.text
    }
  }
}

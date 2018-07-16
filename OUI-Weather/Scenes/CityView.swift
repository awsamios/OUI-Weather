//
//  CityTableView.swift
//  OUI-Weather
//
//  Created by Samira on 09/07/2018.
//  Copyright © 2018 Bands. All rights reserved.
//

import UIKit


protocol WeatherDelegate: class {
  func numberOfItemsInSection() -> Int
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
}

class CityView: UIView {
  
  @IBOutlet weak var cityNameLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!
  @IBOutlet weak var iconImageView: UIImageView!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var tempertureLabel: UILabel!
  @IBOutlet weak var tableView: UITableView!
  
  weak var delegate: WeatherDelegate?
  
  func configure(name: String, desc: String, date: String, temp: String, iconUrl: URL?) {
    self.cityNameLabel.text = name
    self.descriptionLabel.text = desc
    self.dateLabel.text = date
    self.tempertureLabel.text = temp
    self.iconImageView.kf.setImage(with: iconUrl)
  }
}

extension CityView: UITableViewDelegate, UITableViewDataSource {

  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cityCellIdentifier") as! CityTableViewCell
    

    cell.delegate = self.delegate
    cell.collectionView.reloadData()

    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 100
  }
}

class CityTableViewCell: UITableViewCell {
  weak var delegate: WeatherDelegate?
  @IBOutlet weak var collectionView: UICollectionView!
}

extension CityTableViewCell : UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.delegate?.numberOfItemsInSection() ?? 0
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    let cell = self.delegate?.collectionView(collectionView, cellForItemAt: indexPath)
    return cell!
  }
}

extension CityTableViewCell : UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let itemsPerRow: CGFloat = CGFloat(self.delegate?.numberOfItemsInSection() ?? 0)
    let hardCodedPadding: CGFloat = 5
    let itemWidth = (collectionView.bounds.width / itemsPerRow) - hardCodedPadding
    let itemHeight = collectionView.bounds.height - (2 * hardCodedPadding)
    return CGSize(width: itemWidth, height: itemHeight)
  }
}

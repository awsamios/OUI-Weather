//
//  TimeWeatherCollectionViewCell.swift
//  OUI-Weather
//
//  Created by Samira on 16/07/2018.
//  Copyright © 2018 Bands. All rights reserved.
//

import UIKit

class TimeWeatherCollectionViewCell: UICollectionViewCell {
    
  @IBOutlet weak var hourLabel: UILabel!
  @IBOutlet weak var tempertureLabel: UILabel!
  
  func configure(hour: String?, temp: String?) {
    self.hourLabel.text = hour
    self.tempertureLabel.text = temp
  }
}

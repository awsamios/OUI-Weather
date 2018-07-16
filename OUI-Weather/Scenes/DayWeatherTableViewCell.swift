//
//  DayWeatherTableViewCell.swift
//  OUI-Weather
//
//  Created by Samira on 09/07/2018.
//  Copyright © 2018 Bands. All rights reserved.
//

import UIKit
import Kingfisher

class DayWeatherTableViewCell: UITableViewCell {
  
  @IBOutlet weak var maxTempertureLabel: UILabel!
  @IBOutlet weak var minTempertureLabel: UILabel!
  @IBOutlet weak var dayLabel: UILabel!
  @IBOutlet weak var iconImageView: UIImageView!
  
  func configure(maxTemp: String, minTemp: String, day: String?, iconUrl: URL?) {
    
    self.maxTempertureLabel.text = maxTemp
    self.minTempertureLabel.text = minTemp
    self.dayLabel.text = day
    self.iconImageView.kf.setImage(with: iconUrl)
  }
}

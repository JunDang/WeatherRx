//
//  HourlyForecastTableViewCell.swift
//  WeatherRx
//
//  Created by Jun Dang on 2018-05-17.
//  Copyright © 2018 Jun Dang. All rights reserved.
//

import UIKit
import Cartography

class HourlyForecastTableViewCell: UITableViewCell {
    
  var hourlyForecastCollectionView = HourlForecastViewController().collectionView
    
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.selectionStyle = UITableViewCellSelectionStyle.none
    guard hourlyForecastCollectionView != nil else {
        return
      }
    contentView.addSubview(hourlyForecastCollectionView!)
    
    layoutView()
    setStyle()
 
  }
    
    required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
}

extension HourlyForecastTableViewCell {
    func layoutView() {
        constrain(hourlyForecastCollectionView!) {
            $0.top == $0.superview!.top
            $0.bottom == $0.superview!.bottom
            $0.left == $0.superview!.left
            $0.right == $0.superview!.right
       }
    }
}

extension HourlyForecastTableViewCell {
    func setStyle() {
      self.backgroundColor = UIColor.clear
    }
}
    
    



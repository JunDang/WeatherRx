//
//  DailyForecastTableViewCell.swift
//  WeatherRx
//
//  Created by Jun Dang on 2018-05-19.
//  Copyright © 2018 Jun Dang. All rights reserved.
//

import UIKit
import Cartography

class DailyForecastTableViewCell: UITableViewCell {
    private let dayLabel = UILabel()
    private let lowTemp = UILabel()
    private let highTemp = UILabel()
    private let iconImage = UIImageView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = UITableViewCellSelectionStyle.none
        setup()
        layoutView()
        setStyle()
    }
    
    required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
}

extension DailyForecastTableViewCell {
    func setup() {
      contentView.addSubview(dayLabel)
      contentView.addSubview(lowTemp)
      contentView.addSubview(highTemp)
      contentView.addSubview(iconImage)
   }
}

extension DailyForecastTableViewCell {
    func layoutView() {
        constrain(dayLabel) {
          $0.top == $0.superview!.top + 2
          $0.bottom == $0.superview!.top - 2
          $0.left == $0.superview!.left + 5
        }
    }
}


//
//  HourlyForcastCell.swift
//  WeatherRx
//
//  Created by Jun Dang on 2018-05-11.
//  Copyright © 2018 Jun Dang. All rights reserved.
//

import UIKit
import Cartography


class HourlyForecastCell: UICollectionViewCell, UICollectionViewDelegateFlowLayout {
    private var didSetupConstraints = false
    private let iconImage = UIImageView()
    private let hourLbl = UILabel()
    private let tempsLbl = UILabel()
  
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        setup()
        setStyle()
        layoutView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
       if didSetupConstraints {
            super.updateConstraints()
            return
        }
        layoutView()
        super.updateConstraints()
        didSetupConstraints = true
    }
}

private extension HourlyForecastCell {
    func setup() {
        self.contentView.addSubview(iconImage)
        self.contentView.addSubview(hourLbl)
        self.contentView.addSubview(tempsLbl)
    }
}

private extension HourlyForecastCell {
    func layoutView() {
        constrain(iconImage) {
            $0.center == $0.superview!.center
            $0.height == 30
            $0.width == 40
        }
        constrain(hourLbl, iconImage) {
            $0.bottom == $1.top
            $0.top == $0.superview!.top
            $0.width == 42
            $0.height == 30
        }
        constrain(tempsLbl, iconImage) {
            $0.top == $1.bottom
            $0.bottom == $0.superview!.bottom
            $0.width == 42
            $0.height == 30
        }
    }
}

private extension HourlyForecastCell {
    func setStyle() {
        hourLbl.font = UIFont(name: "HelveticaNeue-Bold", size: 13)
        hourLbl.textAlignment = .center
        hourLbl.lineBreakMode = NSLineBreakMode.byWordWrapping
        hourLbl.sizeToFit()
        hourLbl.textColor = UIColor.white
        tempsLbl.font = UIFont(name: "HelveticaNeue-Bold", size: 13)
        tempsLbl.textAlignment = .center
        tempsLbl.lineBreakMode = NSLineBreakMode.byWordWrapping
        tempsLbl.sizeToFit()
        tempsLbl.textColor = UIColor.white
    }
}

extension HourlyForecastCell {
    func updateHourlyCell(with hourlyForecastData: HourlyForecastData) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        hourLbl.text = dateFormatter.string(from: hourlyForecastData.timeDate!)
        tempsLbl.text = "\(hourlyForecastData.temperature.roundToInt())" + "\u{00B0}"
        let iconName = WeatherIcon.iconMap[hourlyForecastData.icon]
       // print("hourlyIconName: " + "\(iconName)")
        iconImage.image = UIImage(named: "\(String(describing: iconName!))")
    }
}

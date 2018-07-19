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
    private let dayLbl = UILabel()
    private let lowTempLbl = UILabel()
    private let highTempLbl = UILabel()
    private let iconImage = UIImageView()
    private var didSetupConstraints = false
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = UITableViewCellSelectionStyle.none
        setup()
        setStyle()
        layoutView()
        //render()
    }
    
    required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        //print("dailycellupdateconstraintscalled")
        if didSetupConstraints {
            super.updateConstraints()
            return
        }
        layoutView()
        super.updateConstraints()
        didSetupConstraints = true
    }
}

private extension DailyForecastTableViewCell {
    func setup() {
      contentView.addSubview(dayLbl)
      contentView.addSubview(lowTempLbl)
      contentView.addSubview(highTempLbl)
      contentView.addSubview(iconImage)
   }
}

private extension DailyForecastTableViewCell {
    func layoutView() {
        constrain(dayLbl) {
          $0.centerY == $0.superview!.centerY
          $0.left == $0.superview!.left + 10
        }
        constrain(iconImage) {
            $0.top == $0.superview!.top + 2
            $0.bottom == $0.superview!.bottom - 2
            $0.centerX == $0.superview!.centerX - 5
            $0.centerY == $0.superview!.centerY
            //$0.width == 50
        }
        constrain(lowTempLbl) {
            $0.centerY == $0.superview!.centerY
            $0.right == $0.superview!.right - 10
        }
        constrain(highTempLbl, lowTempLbl) {
            $0.centerY == $0.superview!.centerY
            $0.right == $1.left - 25
        }
    }
}

private extension DailyForecastTableViewCell {
    func setStyle() {
        self.backgroundColor = UIColor.clear
        
        dayLbl.textColor = UIColor.white
        dayLbl.backgroundColor = UIColor.clear
        dayLbl.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
        dayLbl.sizeToFit()
        
        lowTempLbl.textColor = UIColor.white
        lowTempLbl.backgroundColor = UIColor.clear
        lowTempLbl.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
        lowTempLbl.sizeToFit()
        
        highTempLbl.textColor = UIColor.white
        highTempLbl.backgroundColor = UIColor.clear
        highTempLbl.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
        highTempLbl.sizeToFit()
        
        iconImage.backgroundColor = UIColor.clear
    }
}

extension DailyForecastTableViewCell{
    func updateDailyCell(with dailyForecastData: DailyForecastData){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        dayLbl.text = dateFormatter.string(from: dailyForecastData.timeDate!)
        let iconName = WeatherIcon.iconMap[dailyForecastData.icon]
        iconImage.image = UIImage(named: "\(String(describing: iconName!))")
        lowTempLbl.text = "\(dailyForecastData.temperatureMin.roundToInt())" + "\u{00B0}"
        highTempLbl.text = "\(dailyForecastData.temperatureMax.roundToInt())" + "\u{00B0}"
        print("dailyIconName: " + "\(iconName)")
        /*dayLbl.text = "Saturday"
        iconImage.image = UIImage(named: "sunny")
        lowTempLbl.text = "5\u{00B0}"
        highTempLbl.text = "20\u{00B0}"*/
    }
}




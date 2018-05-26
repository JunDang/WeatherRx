//
//  WeatherForecastGraphViewController.swift
//  WeatherRx
//
//  Created by Jun Dang on 2018-05-21.
//  Copyright © 2018 Jun Dang. All rights reserved.
//

import UIKit
import Cartography

class WeatherForecastGraphViewController: UIViewController {
    
    private let hourlyGraphView = UIView(frame: CGRect.zero)
    private let dailyGraphView = UIView(frame: CGRect.zero)
    private let hourlyLbl = UILabel()
    private let dailyLbl = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        layoutView()
        setStyle()
        render()
    }
}

extension WeatherForecastGraphViewController {
    func setup() {
        view.addSubview(hourlyGraphView)
        view.addSubview(dailyGraphView)
        view.addSubview(hourlyLbl)
        view.addSubview(dailyLbl)
    }
}

extension WeatherForecastGraphViewController {
    func layoutView() {
        constrain(hourlyLbl) {
            $0.top == $0.superview!.top + 10
            $0.left == $0.superview!.left + 10
        }
        constrain(hourlyGraphView, hourlyLbl ) {
            $0.height == $0.superview!.height/2 - 50
            $0.left == $0.superview!.left + 10
            $0.right == $0.superview!.right - 10
            $0.top == $1.bottom
        }
        constrain(dailyLbl, hourlyGraphView) {
            $0.top == $1.bottom + 30
            $0.left == $0.superview!.left + 10
        }
        constrain(dailyGraphView, dailyLbl ) {
            $0.height == $0.superview!.height/2 - 50
            $0.left == $0.superview!.left + 10
            $0.right == $0.superview!.right - 10
            $0.top == $1.bottom
        }
    }
}

extension WeatherForecastGraphViewController {
    func setStyle() {
        view.backgroundColor = UIColor.clear
        hourlyGraphView.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        dailyGraphView.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        hourlyLbl.backgroundColor = UIColor.clear
        hourlyLbl.textColor = UIColor.white
        hourlyLbl.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
        hourlyLbl.sizeToFit()
        dailyLbl.backgroundColor = UIColor.clear
        dailyLbl.textColor = UIColor.white
        dailyLbl.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
        dailyLbl.sizeToFit()
        
    }
}

extension WeatherForecastGraphViewController {
    func render() {
       hourlyLbl.text = "Hourly Forecast Trend"
       dailyLbl.text = "Daily Forecast Trend"
    }


}

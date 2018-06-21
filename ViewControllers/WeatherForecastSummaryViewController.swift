//
//  WeatherForecastSummaryViewController.swift
//  WeatherRx
//
//  Created by Jun Dang on 2018-05-21.
//  Copyright © 2018 Jun Dang. All rights reserved.
//

import UIKit
import Cartography

class WeatherForecastSummaryViewController: UIViewController {
    
    private let toplineView = UIView(frame: CGRect.zero)
    private let bottomlineView = UIView(frame: CGRect.zero)
    private let todayWeatherSummaryLbl = UILabel()
    private let todayWeatherSummaryDataLbl = UILabel()
    private let precipitationChanceLbl = UILabel()
    private let precipitationChanceDataLbl = UILabel()
    private let precipitationLbl = UILabel()
    private let precipitationDataLbl = UILabel()
    private let dewPointLbl = UILabel()
    private let dewPointDataLbl = UILabel()
    private let humidityLbl = UILabel()
    private let humidityDataLbl = UILabel()
    private let windLbl = UILabel()
    private let winddirectionLbl = UILabel()
    private let windDataLbl = UILabel()
    private let sunriseLbl = UILabel()
    private let sunriseDataLbl = UILabel()
    private let sunSetLbl = UILabel()
    private let sunSetDataLbl = UILabel()
    private let cloudCoverLbl = UILabel()
    private let cloudCoverDataLbl = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        layoutView()
        setStyle()
        render()
   }
}

extension WeatherForecastSummaryViewController {
    func setup() {
        view.addSubview(toplineView)
        view.addSubview(bottomlineView)
        view.addSubview(todayWeatherSummaryLbl)
        view.addSubview(todayWeatherSummaryDataLbl)
        view.addSubview(precipitationChanceLbl)
        view.addSubview(precipitationChanceDataLbl)
        view.addSubview(precipitationLbl)
        view.addSubview(precipitationDataLbl)
        view.addSubview(dewPointLbl)
        view.addSubview(dewPointDataLbl)
        view.addSubview(humidityLbl)
        view.addSubview(humidityDataLbl)
        view.addSubview(windLbl)
        view.addSubview(winddirectionLbl)
        view.addSubview(windDataLbl)
        view.addSubview(sunriseLbl)
        view.addSubview(sunriseDataLbl)
        view.addSubview(sunSetLbl)
        view.addSubview(sunSetDataLbl)
        view.addSubview(cloudCoverLbl)
        view.addSubview(cloudCoverDataLbl)
    }
}

extension WeatherForecastSummaryViewController {
    func layoutView() {
        constrain(todayWeatherSummaryLbl) {
            $0.top == $0.superview!.top + 10
            $0.left == $0.superview!.left + 10
        }
        constrain(todayWeatherSummaryDataLbl, todayWeatherSummaryLbl) {
            $0.top == $1.top
            $0.bottom == $1.bottom
            $0.left == $1.right + 2
        }
        constrain(toplineView, todayWeatherSummaryLbl ) {
            $0.height == 1
            $0.left == $1.left
            $0.right == $0.superview!.right - 10
            $0.top == $1.bottom
        }
        constrain(precipitationChanceLbl, toplineView ) {
            $0.top == $1.bottom + 2
            $0.right == $0.superview!.centerX
        }
        constrain(precipitationChanceDataLbl, precipitationChanceLbl) {
            $0.top == $1.top
            $0.bottom == $1.bottom
            $0.left == $1.right + 2
        }
        constrain(precipitationLbl, precipitationChanceLbl) {
            $0.top == $1.bottom
            $0.right == $1.right
        }
        constrain(precipitationDataLbl, precipitationLbl) {
            $0.top == $1.top
            $0.bottom == $1.bottom
            $0.left == $1.right + 2
        }
        constrain(dewPointLbl, precipitationChanceLbl) {
            $0.top == $1.bottom
            $0.right == $1.right
        }
        constrain(dewPointDataLbl, dewPointLbl) {
            $0.top == $1.top
            $0.bottom == $1.bottom
            $0.left == $1.right + 2
        }
        constrain(humidityLbl, dewPointLbl) {
            $0.top == $1.bottom
            $0.right == $1.right
        }
        constrain(humidityDataLbl, humidityLbl) {
            $0.top == $1.top
            $0.bottom == $1.bottom
            $0.left == $1.right + 2
        }
        constrain(windLbl, humidityLbl) {
            $0.top == $1.bottom
            $0.right == $1.right
        }
        constrain(winddirectionLbl, windLbl) {
            $0.top == $1.top
            $0.bottom == $1.bottom
            $0.left == $1.right + 2
        }
        constrain(windDataLbl, winddirectionLbl) {
            $0.top == $1.top
            $0.bottom == $1.bottom
            $0.left == $1.right + 2
        }
        constrain(sunriseLbl, windLbl) {
            $0.top == $1.bottom
            $0.right == $1.right
        }
        constrain(sunriseDataLbl, sunriseLbl) {
            $0.top == $1.top
            $0.bottom == $1.bottom
            $0.left == $1.right + 2
        }
        constrain(sunSetLbl, sunriseLbl) {
            $0.top == $1.bottom
            $0.right == $1.right
        }
        constrain(sunSetDataLbl, sunSetLbl) {
            $0.top == $1.top
            $0.bottom == $1.bottom
            $0.left == $1.right + 2
        }
        constrain(cloudCoverLbl, sunSetLbl) {
            $0.top == $1.bottom
            $0.right == $1.right
        }
        constrain(cloudCoverDataLbl, cloudCoverLbl) {
            $0.top == $1.top
            $0.bottom == $1.bottom
            $0.left == $1.right + 2
        }
        constrain(bottomlineView, cloudCoverLbl) {
            $0.height == 1
            $0.top == $1.bottom + 10
            $0.left == $0.superview!.left + 10
            $0.right == $0.superview!.right - 10
        }
    }
}

extension WeatherForecastSummaryViewController {
    func setStyle() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        
        toplineView.backgroundColor = UIColor.white
        bottomlineView.backgroundColor = UIColor.white
        
        todayWeatherSummaryLbl.backgroundColor = UIColor.clear
        todayWeatherSummaryLbl.textColor = UIColor.white
        todayWeatherSummaryLbl.font = UIFont(name: "HelveticaNeue-Bold", size: 15)
        todayWeatherSummaryLbl.textAlignment = .right
        todayWeatherSummaryLbl.sizeToFit()
        todayWeatherSummaryDataLbl.backgroundColor = UIColor.clear
        todayWeatherSummaryDataLbl.textColor = UIColor.white
        todayWeatherSummaryDataLbl.font = UIFont(name: "HelveticaNeue-Bold", size: 15)
        todayWeatherSummaryDataLbl.textAlignment = .left
        todayWeatherSummaryDataLbl.sizeToFit()
        
        precipitationChanceLbl.backgroundColor = UIColor.clear
        precipitationChanceLbl.textColor = UIColor.white
        precipitationChanceLbl.font = UIFont(name: "HelveticaNeue-Bold", size: 15)
        precipitationChanceLbl.textAlignment = .right
        precipitationChanceLbl.sizeToFit()
        precipitationChanceDataLbl.backgroundColor = UIColor.clear
        precipitationChanceDataLbl.textColor = UIColor.white
        precipitationChanceDataLbl.font = UIFont(name: "HelveticaNeue-Bold", size: 15)
        precipitationChanceDataLbl.textAlignment = .left
        precipitationChanceDataLbl.sizeToFit()
        
        dewPointLbl.backgroundColor = UIColor.clear
        dewPointLbl.textColor = UIColor.white
        dewPointLbl.font = UIFont(name: "HelveticaNeue-Bold", size: 15)
        dewPointLbl.textAlignment = .right
        dewPointLbl.sizeToFit()
        dewPointDataLbl.backgroundColor = UIColor.clear
        dewPointDataLbl.textColor = UIColor.white
        dewPointDataLbl.font = UIFont(name: "HelveticaNeue-Bold", size: 15)
        dewPointDataLbl.textAlignment = .left
        dewPointDataLbl.sizeToFit()
        
        humidityLbl.backgroundColor = UIColor.clear
        humidityLbl.textColor = UIColor.white
        humidityLbl.font = UIFont(name: "HelveticaNeue-Bold", size: 15)
        humidityLbl.textAlignment = .right
        humidityLbl.sizeToFit()
        humidityDataLbl.backgroundColor = UIColor.clear
        humidityDataLbl.textColor = UIColor.white
        humidityDataLbl.font = UIFont(name: "HelveticaNeue-Bold", size: 15)
        humidityDataLbl.textAlignment = .left
        humidityDataLbl.sizeToFit()
        
        windLbl.backgroundColor = UIColor.clear
        windLbl.textColor = UIColor.white
        windLbl.font = UIFont(name: "HelveticaNeue-Bold", size: 15)
        windLbl.textAlignment = .right
        windLbl.sizeToFit()
        winddirectionLbl.backgroundColor = UIColor.clear
        winddirectionLbl.textColor = UIColor.white
        winddirectionLbl.font = UIFont(name: "HelveticaNeue-Bold", size: 15)
        winddirectionLbl.textAlignment = .right
        winddirectionLbl.sizeToFit()
        windDataLbl.backgroundColor = UIColor.clear
        windDataLbl.textColor = UIColor.white
        windDataLbl.font = UIFont(name: "HelveticaNeue-Bold", size: 15)
        windDataLbl.textAlignment = .left
        windDataLbl.sizeToFit()
        
        sunriseLbl.backgroundColor = UIColor.clear
        sunriseLbl.textColor = UIColor.white
        sunriseLbl.font = UIFont(name: "HelveticaNeue-Bold", size: 15)
        sunriseLbl.textAlignment = .right
        sunriseLbl.sizeToFit()
        sunriseDataLbl.backgroundColor = UIColor.clear
        sunriseDataLbl.textColor = UIColor.white
        sunriseDataLbl.font = UIFont(name: "HelveticaNeue-Bold", size: 15)
        sunriseDataLbl.textAlignment = .left
        sunriseDataLbl.sizeToFit()
        
        sunSetLbl.backgroundColor = UIColor.clear
        sunSetLbl.textColor = UIColor.white
        sunSetLbl.font = UIFont(name: "HelveticaNeue-Bold", size: 15)
        sunSetLbl.textAlignment = .right
        sunSetLbl.sizeToFit()
        sunSetDataLbl.backgroundColor = UIColor.clear
        sunSetDataLbl.textColor = UIColor.white
        sunSetDataLbl.font = UIFont(name: "HelveticaNeue-Bold", size: 15)
        sunSetDataLbl.textAlignment = .left
        sunSetDataLbl.sizeToFit()
        
        cloudCoverLbl.backgroundColor = UIColor.clear
        cloudCoverLbl.textColor = UIColor.white
        cloudCoverLbl.font = UIFont(name: "HelveticaNeue-Bold", size: 15)
        cloudCoverLbl.textAlignment = .right
        cloudCoverLbl.sizeToFit()
        cloudCoverDataLbl.backgroundColor = UIColor.clear
        cloudCoverDataLbl.textColor = UIColor.white
        cloudCoverDataLbl.font = UIFont(name: "HelveticaNeue-Bold", size: 15)
        cloudCoverDataLbl.textAlignment = .left
        cloudCoverDataLbl.sizeToFit()
     }
 }

extension WeatherForecastSummaryViewController {
    func render() {
        todayWeatherSummaryLbl.text = "Today Weather: "
        todayWeatherSummaryDataLbl.text = "Sunny all day"
        precipitationChanceLbl.text = "Chance of Precipitation: "
        precipitationChanceDataLbl.text = "0%"
        dewPointLbl.text = "Dew point: "
        dewPointDataLbl.text = "42.52"
        humidityLbl.text = "Humidity: "
        humidityDataLbl.text = "85%"
        windLbl.text = "Wind: "
        winddirectionLbl.text = "NW"
        windDataLbl.text = " 8 mph"
        sunriseLbl.text = "Sunrise: "
        sunriseDataLbl.text = "06:00"
        sunSetLbl.text = "Sunset: "
        sunSetDataLbl.text = "20:00"
        cloudCoverLbl.text = "Cloud Cover: "
        cloudCoverDataLbl.text = "0.85"
        
    }
}


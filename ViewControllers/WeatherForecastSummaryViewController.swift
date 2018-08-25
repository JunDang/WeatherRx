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
    private let precipitationLbl = UILabel()
    private let precipIntensityLbl = UILabel()
    private let dewPointLbl = UILabel()
    private let humidityLbl = UILabel()
    private let windLbl = UILabel()
    private let sunriseLbl = UILabel()
    private let sunSetLbl = UILabel()
    private let cloudCoverLbl = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        layoutView()
        setStyle()
        //render()
   }
}

extension WeatherForecastSummaryViewController {
    func setup() {
        view.addSubview(toplineView)
        view.addSubview(bottomlineView)
        view.addSubview(todayWeatherSummaryLbl)
        view.addSubview(precipitationLbl)
        view.addSubview(precipIntensityLbl)
        view.addSubview(dewPointLbl)
        view.addSubview(humidityLbl)
        view.addSubview(windLbl)
        view.addSubview(sunriseLbl)
        view.addSubview(sunSetLbl)
        view.addSubview(cloudCoverLbl)
     }
}

extension WeatherForecastSummaryViewController {
    func layoutView() {
        constrain(todayWeatherSummaryLbl) {
            $0.top == $0.superview!.top + 10
            $0.centerX == $0.superview!.centerX
        }
        constrain(toplineView, todayWeatherSummaryLbl ) {
            $0.height == 1
            $0.left == $0.superview!.left + 10
            $0.right == $0.superview!.right - 10
            $0.top == $1.bottom
        }
        constrain(precipitationLbl, toplineView) {
            $0.top == $1.bottom
            $0.centerX == $0.superview!.centerX
        }
        constrain(precipIntensityLbl, precipitationLbl) {
            $0.top == $1.bottom
            $0.centerX == $0.superview!.centerX
        }
        constrain(dewPointLbl, precipIntensityLbl) {
            $0.top == $1.bottom
            $0.centerX == $0.superview!.centerX
        }
        constrain(humidityLbl, dewPointLbl) {
            $0.top == $1.bottom
            $0.centerX == $0.superview!.centerX
        }
        constrain(windLbl, humidityLbl) {
            $0.top == $1.bottom
            $0.centerX == $0.superview!.centerX
        }
        constrain(sunriseLbl, windLbl) {
            $0.top == $1.bottom
            $0.centerX == $0.superview!.centerX
        }
        constrain(sunSetLbl, sunriseLbl) {
            $0.top == $1.bottom
            $0.centerX == $0.superview!.centerX
        }
        constrain(cloudCoverLbl, sunSetLbl) {
            $0.top == $1.bottom
            $0.centerX == $0.superview!.centerX
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
        todayWeatherSummaryLbl.textAlignment = .center
        todayWeatherSummaryLbl.sizeToFit()
        
        precipitationLbl.backgroundColor = UIColor.clear
        precipitationLbl.textColor = UIColor.white
        precipitationLbl.font = UIFont(name: "HelveticaNeue-Bold", size: 15)
        precipitationLbl.textAlignment = .center
        precipitationLbl.sizeToFit()
        
        precipIntensityLbl.backgroundColor = UIColor.clear
        precipIntensityLbl.textColor = UIColor.white
        precipIntensityLbl.font = UIFont(name: "HelveticaNeue-Bold", size: 15)
        precipIntensityLbl.textAlignment = .center
        precipIntensityLbl.sizeToFit()
        
        dewPointLbl.backgroundColor = UIColor.clear
        dewPointLbl.textColor = UIColor.white
        dewPointLbl.font = UIFont(name: "HelveticaNeue-Bold", size: 15)
        dewPointLbl.textAlignment = .center
        dewPointLbl.sizeToFit()
      
        humidityLbl.backgroundColor = UIColor.clear
        humidityLbl.textColor = UIColor.white
        humidityLbl.font = UIFont(name: "HelveticaNeue-Bold", size: 15)
        humidityLbl.textAlignment = .center
        humidityLbl.sizeToFit()
 
        windLbl.backgroundColor = UIColor.clear
        windLbl.textColor = UIColor.white
        windLbl.font = UIFont(name: "HelveticaNeue-Bold", size: 15)
        windLbl.textAlignment = .center
        windLbl.sizeToFit()
  
        sunriseLbl.backgroundColor = UIColor.clear
        sunriseLbl.textColor = UIColor.white
        sunriseLbl.font = UIFont(name: "HelveticaNeue-Bold", size: 15)
        sunriseLbl.textAlignment = .center
        sunriseLbl.sizeToFit()

        sunSetLbl.backgroundColor = UIColor.clear
        sunSetLbl.textColor = UIColor.white
        sunSetLbl.font = UIFont(name: "HelveticaNeue-Bold", size: 15)
        sunSetLbl.textAlignment = .center
        sunSetLbl.sizeToFit()
  
        cloudCoverLbl.backgroundColor = UIColor.clear
        cloudCoverLbl.textColor = UIColor.white
        cloudCoverLbl.font = UIFont(name: "HelveticaNeue-Bold", size: 15)
        cloudCoverLbl.textAlignment = .center
        cloudCoverLbl.sizeToFit()
     }
 }

extension WeatherForecastSummaryViewController {
    /*func render() {
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
        
    }*/
    func updateSummary(with weatherForecastModel: WeatherForecastModel) {
        let todayWeatherData = weatherForecastModel.daily?.dailyWeatherModel[0]
        guard todayWeatherData != nil else {
            return
        }
        todayWeatherSummaryLbl.text = "Today Weather: \(String(describing: todayWeatherData!.summary))"
        //todayWeatherSummaryDataLbl.text = "\(todayWeatherData?.summary)"
        let precipChance = todayWeatherData!.precipProbability
        let precipType = todayWeatherData!.precipType
        let precipIntensity = todayWeatherData!.precipIntensity
        precipitationLbl.text = "Chance of Precipitation:  \(precipChance.roundToInt())%"
        //precipIntensityLbl.text = "Precipitation: \(precipIntensity) \(precipType)"
        let dewPoint = todayWeatherData!.dewPoint
        dewPointLbl.text = "Dew point:  \(dewPoint.rounded(toPlaces: 2))"
        let humidity = todayWeatherData!.humidity
        humidityLbl.text = "Humidity: \(humidity * 100.rounded(toPlaces: 2))%"
        let windDirection = WindDirection(windBearing: todayWeatherData!.windBearing).windDirection
        print("windDirection: \(String(describing: windDirection))")
        let windSpeed = todayWeatherData!.windSpeed
        let unitChange =  UserDefaults.standard.string(forKey: "UnitChange")
        if unitChange == "convertToImperial" {
            precipIntensityLbl.text = "Precipitation: \(precipIntensity.rounded(toPlaces: 2)) inch \(precipType)"
            windLbl.text = "Wind: \(windDirection!) \(windSpeed.rounded(toPlaces: 2)) MPH"
        } else {
            precipIntensityLbl.text = "Precipitation: \(precipIntensity.toCentimeter().rounded(toPlaces: 2)) cm \(precipType)"
            windLbl.text = "Wind: \(windDirection!) \(windSpeed.toKPH().rounded(toPlaces: 2)) KPH"
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        sunriseLbl.text = "Sunrise: \(dateFormatter.string(from: todayWeatherData!.sunriseTimeDate!))"
        sunSetLbl.text = "Sunset: \(dateFormatter.string(from: todayWeatherData!.sunsetTimeDate!))"
        cloudCoverLbl.text = "Cloud Cover: \(todayWeatherData!.cloudCover.rounded(toPlaces: 2))"
    }
}


  //
//  CurrentWeatherView.swift
//  WeatherRx
//
//  Created by Jun Dang on 2018-05-06.
//  Copyright © 2018 Jun Dang. All rights reserved.
//

import UIKit
import Cartography
import RxSwift
import RxCocoa

class CurrentWeatherView: UIView {
    private var didSetupConstraints = false
    private let currentTempLbl = UILabel()
    private let highTempLbl = UILabel()
    private let lowTempLbl = UILabel()
    private let feelsLikeTempLbl = UILabel()
    private let iconImage = UIImageView()
    private let weatherLbl = UILabel()
    private let minutelySummaryLbl = UILabel()
    //var currentWeather: CurrentlyWeatherModel?
    //var weatherViewModel: WeatherViewModel?
 
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setStyle()
        layoutView()
    }
    
    required init(coder aDecoder: NSCoder) {
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

// MARK: Setup View
private extension CurrentWeatherView{
    func setupView(){
        addSubview(currentTempLbl)
        addSubview(highTempLbl)
        addSubview(lowTempLbl)
        addSubview(feelsLikeTempLbl)
        addSubview(iconImage)
        addSubview(weatherLbl)
        addSubview(minutelySummaryLbl)
    }
}

// MARK: Layout
private extension CurrentWeatherView{
    func layoutView(){
        constrain(self) {
            $0.height == 180.0
        }
        constrain(iconImage) {
            $0.top == $0.superview!.top
            $0.left == $0.superview!.left + 10
            $0.width == 78
            $0.height == 60
        }
        constrain(weatherLbl, iconImage) {
            $0.top == $1.top
            $0.left == $1.right + 10
            $0.height == $1.height
        }
        constrain(lowTempLbl, iconImage) {
            $0.top == $1.bottom
            $0.left == $1.left
        }
        constrain(highTempLbl, lowTempLbl) {
            $0.top == $1.top
            $0.bottom == $1.bottom
            $0.left == $1.right + 10
        }
        constrain(feelsLikeTempLbl, highTempLbl) {
            $0.top == $1.top
            $0.bottom == $1.bottom
            $0.left == $1.right + 10
        }
        constrain(currentTempLbl, lowTempLbl) {
            $0.top == $1.bottom
            $0.left == $1.left
            $0.bottom == $0.superview!.bottom
        }
        constrain(minutelySummaryLbl, currentTempLbl) {
            $0.bottom == $1.bottom
            $0.left == $1.right + 8
            $0.bottom == $0.superview!.bottom
        }
    }
}

// MARK: Style
private extension CurrentWeatherView{
    func setStyle(){
        self.backgroundColor = UIColor.clear
        
        weatherLbl.font = UIFont(name: "HelveticaNeue-Bold", size: 19)
        weatherLbl.textColor = UIColor.white
        weatherLbl.sizeToFit()
        weatherLbl.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        currentTempLbl.font = UIFont(name: "Helvetica Neue", size: 75)
        currentTempLbl.textColor = UIColor.white
        currentTempLbl.sizeToFit()
        
        feelsLikeTempLbl.font = UIFont(name: "HelveticaNeue-Bold", size: 16)
        feelsLikeTempLbl.textColor = UIColor.white
        feelsLikeTempLbl.sizeToFit()
        
        minutelySummaryLbl.font = UIFont(name: "HelveticaNeue-Bold", size: 16)
        minutelySummaryLbl.textColor = UIColor.white
        minutelySummaryLbl.sizeToFit()
        minutelySummaryLbl.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        lowTempLbl.font = UIFont(name: "HelveticaNeue-Bold", size: 16)
        lowTempLbl.textColor = UIColor.white
        lowTempLbl.sizeToFit()
        
        highTempLbl.font = UIFont(name: "HelveticaNeue-Bold", size: 16)
        highTempLbl.textColor = UIColor.white
        highTempLbl.sizeToFit()
        
    }
}

// MARK: Render
extension CurrentWeatherView{
  
    func update(with weatherForecastModel: WeatherForecastModel){
             let currentWeather = weatherForecastModel.currently
             weatherLbl.text = currentWeather!.summary
             let iconName = WeatherIcon.iconMap[(currentWeather?.icon)!]
             iconImage.image = UIImage(named: "\(String(describing: iconName!))")
            
             let currentDaily = weatherForecastModel.daily?.dailyWeatherModel.first
        
             let minutelySummary = weatherForecastModel.minutely?.summary
             minutelySummaryLbl.text = minutelySummary
        
             let unitChange =  UserDefaults.standard.string(forKey: "UnitChange")
             if unitChange == "convertToImperial" {
                currentTempLbl.text = "\(String(describing: currentWeather!.temperature.roundToInt()))" + "\u{00B0}" + "F"
                feelsLikeTempLbl.text = "Feels like: " + "\(String(describing: currentWeather!.apparentTemperature.roundToInt()))" + "\u{00B0}" + "F"
                lowTempLbl.text = "min: " + "\(String(describing: currentDaily!.temperatureMin.roundToInt()))" + "\u{00B0}"  + "F"
                highTempLbl.text = "max: " + "\(String(describing: currentDaily!.temperatureMax.roundToInt()))" + "\u{00B0}" + "F"
             } else {
                currentTempLbl.text = "\(String(describing: currentWeather!.temperature.toCelcius().roundToInt()))" + "\u{00B0}" + "C"
                feelsLikeTempLbl.text = "Feels like: " + "\(String(describing: currentWeather!.apparentTemperature.toCelcius().roundToInt()))" + "\u{00B0}" + "C"
                lowTempLbl.text = "min: " + "\(String(describing: currentDaily!.temperatureMin.toCelcius().roundToInt()))" + "\u{00B0}"  + "C"
                highTempLbl.text = "max: " + "\(String(describing: currentDaily!.temperatureMax.toCelcius().roundToInt()))" + "\u{00B0}" + "C"
             }
        
    }

}

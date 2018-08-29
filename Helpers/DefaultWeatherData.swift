//
//  DefaultWeatherData.swift
//  WeatherRx
//
//  Created by Jun Dang on 2018-08-15.
//  Copyright © 2018 Jun Dang. All rights reserved.
//

import Foundation
import RealmSwift

/*class DefaultWeatherData {
    var defaultWeatherData: WeatherForecastModel?
    init(defaultWeatherData: WeatherForecastModel) {
        self.defaultWeatherData = defaultWeatherData
        defaultWeatherData.latitude = 0.0
        defaultWeatherData.longitude = 0.0
        defaultWeatherData.currently? = CurrentlyWeatherModel()
        defaultWeatherData.currently?.time = 0
        defaultWeatherData.currently?.timeDate = nil
        defaultWeatherData.currently?.summary = ""
        defaultWeatherData.currently?.icon = ""
        defaultWeatherData.currently?.temperature = 0.0
        defaultWeatherData.currently?.apparentTemperature = 0.0
        defaultWeatherData.daily?.dailyWeatherModel.first?.time = 0
        defaultWeatherData.daily?.dailyWeatherModel.first?.timeDate = nil
        defaultWeatherData.daily?.dailyWeatherModel.first?.temperatureMax = 0.0
        defaultWeatherData.daily?.dailyWeatherModel.first?.temperatureMin = 0.0
        defaultWeatherData.daily?.dailyWeatherModel.first?.icon = ""
        defaultWeatherData.daily?.dailyWeatherModel.first?.sunsetTime = 0
        defaultWeatherData.daily?.dailyWeatherModel.first?.sunriseTime = 0
        defaultWeatherData.daily?.dailyWeatherModel.first?.sunriseTimeDate = nil
        defaultWeatherData.daily?.dailyWeatherModel.first?.sunsetTimeDate = nil
        defaultWeatherData.daily?.dailyWeatherModel.first?.precipType = ""
        defaultWeatherData.daily?.dailyWeatherModel.first?.precipProbability = 0.0
        defaultWeatherData.daily?.dailyWeatherModel.first?.precipIntensity = 0.0
        defaultWeatherData.daily?.dailyWeatherModel.first?.dewPoint = 0.0
        defaultWeatherData.daily?.dailyWeatherModel.first?.pressure = 0.0
        defaultWeatherData.daily?.dailyWeatherModel.first?.humidity = 0.0
        defaultWeatherData.daily?.dailyWeatherModel.first?.windSpeed = 0.0
        defaultWeatherData.daily?.dailyWeatherModel.first?.windBearing = 0.0
        defaultWeatherData.daily?.dailyWeatherModel.first?.cloudCover = 0.0
        defaultWeatherData.daily?.dailyWeatherModel.first?.ozone = 0.0
        defaultWeatherData.hourly?.hourlyWeatherModel.first?.timeDate = nil
        defaultWeatherData.hourly?.hourlyWeatherModel.first?.time = 0
        defaultWeatherData.hourly?.hourlyWeatherModel.first?.icon = ""
        defaultWeatherData.hourly?.hourlyWeatherModel.first?.temperature = 0.0
        defaultWeatherData.minutely?.summary = ""
        
    }
    
    convenience required init() {
       self.init()
    }
  
}*/
class DefaultWeatherData {
    var defaultWeatherData: WeatherForecastModel?
    init() {
       
        defaultWeatherData?.latitude = 0.0
        defaultWeatherData?.longitude = 0.0
        defaultWeatherData?.currently? = CurrentlyWeatherModel()
        defaultWeatherData?.daily? = DailyWeatherModel()
        defaultWeatherData?.minutely? = MinutelyWeatherModel()
        
    }
    
    /*convenience required init() {
        self.init()
  }*/

}




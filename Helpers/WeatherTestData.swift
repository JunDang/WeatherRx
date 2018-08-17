//
//  Weather.swift
//  WeatherRx
//
//  Created by Jun Dang on 2017-09-25.
//  Copyright © 2017 Jun Dang. All rights reserved.
//

import Foundation


class WeatherForecastModelTest {
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    var currently: CurrentlyWeatherModelTest?
    var hourly: HourlyWeatherModelTest?
    var daily: DailyWeatherModelTest?
    var minutely: MinutelyWeatherModelTest?
}

class CurrentlyWeatherModelTest {
    var time: Int = 0
    var timeDate: Date?
    var summary: String = ""
    var icon: String = ""
    var temperature: Double = 0.0
    var apparentTemperature: Double = 0.0
}

class DailyWeatherModelTest {
    var dailyWeatherModel: [DailyForecastDataTest] = []
}

class DailyForecastDataTest {
    var time: Int = 0
    var timeDate: Date?
    var temperatureMax: Double  = 0.0
    var temperatureMin: Double  = 0.0
    var icon: String = ""
    var sunriseTime: Int = 0
    var sunriseTimeDate: Date?
    var sunsetTime: Int = 0
    var sunsetTimeDate: Date?
    var precipType: String = ""
    var precipProbability: Double = 0.0
    var precipIntensity: Double = 0.0
    var dewPoint: Double = 0.0
    var pressure: Double = 0.0
    var humidity: Double = 0.0
    var windSpeed: Double = 0.0
    var windBearing: Double = 0.0
    var cloudCover: Double = 0.0
    var uvIndex: Int = 0
    var visibility: Double = 0.0
    var ozone: Double = 0.0
}

class HourlyWeatherModelTest {
    var hourlyWeatherModel: [HourlyForecastDataTest] = []
}

class HourlyForecastDataTest {
    var timeDate: Date?
    var time: Int = 0
    var icon: String = ""
    var temperature: Double = 0.0
}

class MinutelyWeatherModelTest {
    var summary: String = ""
}





























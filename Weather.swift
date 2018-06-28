//
//  Weather.swift
//  WeatherRx
//
//  Created by Jun Dang on 2017-09-25.
//  Copyright © 2017 Jun Dang. All rights reserved.
//

import Foundation
import RealmSwift


struct WeatherForecastModel: Codable {
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    var currently: CurrentlyWeatherModel?
    var hourly: HourlyWeatherModel?
    var daily: DailyWeatherModel?
   
    enum CodingKeys : String, CodingKey {
        case latitude = "latitude"
        case longitude = "longitude"
        case currently = "currently"
        case hourly = "hourly"
        case daily = "daily"
    }
  
 }

struct CurrentlyWeatherModel: Codable {
    var time: Int = 0
    var summary: String = ""
    var icon: String = ""
    var temperature: Double = 0.0
    var apparentTemperature: Double = 0.0
    private enum CodingKeys : String, CodingKey {
        case time = "time"
        case summary = "summary"
        case icon = "icon"
        case temperature = "temperature"
        case apparentTemperature = "apparentTemperature"
    }
    init(time: Int, summary: String, icon: String, temperature: Double, apparentTemperature: Double ) {
        self.time = time
        self.summary = summary
        self.icon = icon
        self.temperature = temperature
        self.apparentTemperature = apparentTemperature
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        time = try container.decode(Int.self, forKey: .time)
        summary = try container.decode(String.self, forKey: .summary)
        icon = try container.decode(String.self, forKey: .icon)
        temperature = try container.decode(Double.self, forKey: .temperature)
        apparentTemperature = try container.decode(Double.self, forKey: .apparentTemperature)
    }
}

struct DailyWeatherModel: Codable {
    private enum CodingKeys : String, CodingKey {
        case dailyWeatherModel = "data" }
    var dailyWeatherModel: [DailyForecastData] = []
}

struct DailyForecastData: Codable {
    var temperatureMax: Double  = 0.0
    var temperatureMin: Double  = 0.0
    var icon: String = ""
    var sunriseTime: Double  = 0.0
    var sunsetTime: Double  = 0.0
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
    private enum CodingKeys : String, CodingKey {
        case temperatureMax = "temperatureMax"
        case temperatureMin = "temperatureMin"
        case icon = "icon"
        case sunriseTime = "sunriseTime"
        case sunsetTime = "sunsetTime"
        case precipType = "precipType"
        case precipProbability = "precipProbability"
        case precipIntensity = "precipIntensity"
        case dewPoint = "dewPoint"
        case pressure = "pressure"
        case humidity = "humidity"
        case windSpeed = "windSpeed"
        case windBearing = "windBearing"
        case cloudCover = "cloudCover"
        case uvIndex = "uvIndex"
        case visibility = "visibility"
        case ozone = "ozone"
    }
    init(temperatureMax: Double, temperatureMin: Double, icon: String, sunriseTime: Double, sunsetTime: Double, precipType: String?, precipProbability: Double, precipIntensity: Double, dewPoint: Double, pressure: Double, humidity: Double, windSpeed: Double, windBearing: Double, cloudCover: Double, uvIndex: Int, visibility: Double, ozone: Double ) {
        self.temperatureMax = temperatureMax
        self.temperatureMin = temperatureMin
        self.icon = icon
        self.sunriseTime = sunriseTime
        self.sunsetTime = sunsetTime
        if let precipType = precipType {
           self.precipType = precipType
        } else {
            self.precipType = ""
        }
        self.precipProbability = precipProbability
        self.precipIntensity = precipIntensity
        self.dewPoint = dewPoint
        self.pressure = pressure
        self.humidity = humidity
        self.windSpeed = windSpeed
        self.windBearing = windBearing
        self.cloudCover = cloudCover
        self.uvIndex = uvIndex
        self.visibility = visibility
        self.ozone = ozone
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        temperatureMax = try container.decode(Double.self, forKey: .temperatureMax)
        temperatureMin = try container.decode(Double.self, forKey: .temperatureMin)
        icon = try container.decode(String.self, forKey: .icon)
        sunriseTime = try container.decode(Double.self, forKey: .sunriseTime)
        sunsetTime = try container.decode(Double.self, forKey: .sunsetTime)
       // precipType = try container.decode(String.self, forKey: .precipType)
        precipType = try container.decodeIfPresent(String.self, forKey: .precipType) ?? ""
        precipProbability = try container.decode(Double.self, forKey: .temperatureMin)
        precipIntensity = try container.decode(Double.self, forKey: .precipIntensity)
        dewPoint = try container.decode(Double.self, forKey: .dewPoint)
        pressure = try container.decode(Double.self, forKey: .pressure)
        humidity = try container.decode(Double.self, forKey: .humidity)
        windSpeed = try container.decode(Double.self, forKey: .windSpeed)
        windBearing = try container.decode(Double.self, forKey: .windBearing)
        cloudCover = try container.decode(Double.self, forKey: .cloudCover)
        uvIndex = try container.decode(Int.self, forKey: .uvIndex)
        visibility = try container.decode(Double.self, forKey: .visibility)
        ozone = try container.decode(Double.self, forKey: .ozone)
    }
}

struct HourlyWeatherModel: Codable {
    private enum CodingKeys : String, CodingKey {
        case hourlyWeatherModel = "data" }
    var hourlyWeatherModel: [HourlyForecastData] = []
}

struct HourlyForecastData: Codable {
    var time: Int = 0
    var icon: String = ""
    var temperature: Double = 0.0
    private enum CodingKeys : String, CodingKey {
        case time = "time"
        case icon = "icon"
        case temperature = "temperature"
    }
    init(time: Int, icon: String, temperature: Double) {
        self.time = time
        self.icon = icon
        self.temperature = temperature
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        time = try container.decode(Int.self, forKey: .time)
        icon = try container.decode(String.self, forKey: .icon)
        temperature = try container.decode(Double.self, forKey: .temperature)
    }
}














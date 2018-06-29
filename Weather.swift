//
//  Weather.swift
//  WeatherRx
//
//  Created by Jun Dang on 2017-09-25.
//  Copyright © 2017 Jun Dang. All rights reserved.
//

import Foundation
import RealmSwift
import Realm


class WeatherForecastModel: Object, Decodable {
   @objc dynamic var latitude: Double = 0.0
   @objc dynamic var longitude: Double = 0.0
   @objc dynamic var currently: CurrentlyWeatherModel?
   @objc dynamic var hourly: HourlyWeatherModel?
   @objc dynamic var daily: DailyWeatherModel?
   
    enum WeatherCodingKeys : String, CodingKey {
        case latitude = "latitude"
        case longitude = "longitude"
        case currently = "currently"
        case hourly = "hourly"
        case daily = "daily"
    }
  
 }

class CurrentlyWeatherModel: Object, Decodable {
    @objc var time: Int = 0
    @objc var timeDate: Date?
    @objc var summary: String = ""
    @objc var icon: String = ""
    @objc var temperature: Double = 0.0
    @objc var apparentTemperature: Double = 0.0
    private enum CurrentlyCodingKeys : String, CodingKey {
        case time = "time"
        case summary = "summary"
        case icon = "icon"
        case temperature = "temperature"
        case apparentTemperature = "apparentTemperature"
    }
    convenience init(time: Int, summary: String, icon: String, temperature: Double, apparentTemperature: Double) throws {
        try self.init(time: time, summary: summary, icon: icon, temperature: temperature, apparentTemperature: apparentTemperature)
        self.time = time
        self.summary = summary
        self.icon = icon
        self.temperature = temperature
        self.apparentTemperature = apparentTemperature
    }
    convenience required init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CurrentlyCodingKeys.self)
        time = try container.decode(Int.self, forKey: .time)
        summary = try container.decode(String.self, forKey: .summary)
        icon = try container.decode(String.self, forKey: .icon)
        temperature = try container.decode(Double.self, forKey: .temperature)
        apparentTemperature = try container.decode(Double.self, forKey: .apparentTemperature)
        timeDate = Date(timeIntervalSince1970: TimeInterval(time))
    }
  
}

class DailyWeatherModel: Object, Decodable {
    private enum DailyWeatherCodingKeys : String, CodingKey {
        case dailyWeatherModel = "data" }
   // @objc var dailyWeatherModel: [DailyForecastData] = []
    var dailyWeatherModel = List<DailyForecastData>()
    convenience init(dailyWeatherModel:List<DailyForecastData>) throws {
        self.init()
        self.dailyWeatherModel = dailyWeatherModel
    }
    convenience required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DailyWeatherCodingKeys.self)
        let dailyForecastArray = try container.decode([DailyForecastData].self, forKey: .dailyWeatherModel)
        let dailyForecastList = List<DailyForecastData>()
        dailyForecastList.append(objectsIn: dailyForecastArray)
        try self.init(dailyWeatherModel: dailyForecastList)
    }
}

class DailyForecastData: Object, Codable {
    @objc var temperatureMax: Double  = 0.0
    @objc var temperatureMin: Double  = 0.0
    @objc var icon: String = ""
    @objc var sunriseTime: Double  = 0.0
    @objc var sunsetTime: Double  = 0.0
    @objc var precipType: String = ""
    @objc var precipProbability: Double = 0.0
    @objc var precipIntensity: Double = 0.0
    @objc var dewPoint: Double = 0.0
    @objc var pressure: Double = 0.0
    @objc var humidity: Double = 0.0
    @objc var windSpeed: Double = 0.0
    @objc var windBearing: Double = 0.0
    @objc var cloudCover: Double = 0.0
    @objc var uvIndex: Int = 0
    @objc var visibility: Double = 0.0
    @objc var ozone: Double = 0.0
    private enum DailyCodingKeys : String, CodingKey {
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
    convenience init(temperatureMax: Double, temperatureMin: Double, icon: String, sunriseTime: Double, sunsetTime: Double, precipType: String?, precipProbability: Double, precipIntensity: Double, dewPoint: Double, pressure: Double, humidity: Double, windSpeed: Double, windBearing: Double, cloudCover: Double, uvIndex: Int, visibility: Double, ozone: Double ) {
        self.init()
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
   convenience required init(from decoder: Decoder) throws {
    
        let container = try decoder.container(keyedBy: DailyCodingKeys.self)
        let temperatureMax = try container.decode(Double.self, forKey: .temperatureMax)
        let temperatureMin = try container.decode(Double.self, forKey: .temperatureMin)
        let icon = try container.decode(String.self, forKey: .icon)
        let sunriseTime = try container.decode(Double.self, forKey: .sunriseTime)
        let sunsetTime = try container.decode(Double.self, forKey: .sunsetTime)
       // precipType = try container.decode(String.self, forKey: .precipType)
        let precipType = try container.decodeIfPresent(String.self, forKey: .precipType) ?? ""
        let precipProbability = try container.decode(Double.self, forKey: .temperatureMin)
        let precipIntensity = try container.decode(Double.self, forKey: .precipIntensity)
        let dewPoint = try container.decode(Double.self, forKey: .dewPoint)
        let pressure = try container.decode(Double.self, forKey: .pressure)
        let humidity = try container.decode(Double.self, forKey: .humidity)
        let windSpeed = try container.decode(Double.self, forKey: .windSpeed)
        let windBearing = try container.decode(Double.self, forKey: .windBearing)
        let cloudCover = try container.decode(Double.self, forKey: .cloudCover)
        let uvIndex = try container.decode(Int.self, forKey: .uvIndex)
        let visibility = try container.decode(Double.self, forKey: .visibility)
        let ozone = try container.decode(Double.self, forKey: .ozone)
        self.init(temperatureMax: temperatureMax, temperatureMin: temperatureMin, icon: icon, sunriseTime: sunriseTime, sunsetTime: sunsetTime, precipType: precipType, precipProbability: precipProbability, precipIntensity: precipIntensity, dewPoint: dewPoint, pressure: pressure, humidity: humidity, windSpeed: windSpeed, windBearing: windBearing, cloudCover: cloudCover, uvIndex: uvIndex, visibility: visibility, ozone: ozone)
    }
    
}

class HourlyWeatherModel: Object, Decodable {
    private enum HourlyWeatherCodingKeys : String, CodingKey {
        case hourlyWeatherModel = "data" }
    //@objc var hourlyWeatherModel: [HourlyForecastData] = []
    var hourlyWeatherModel = List<HourlyForecastData>()
    convenience init(hourlyWeatherModel:List<HourlyForecastData>) throws {
        self.init()
        self.hourlyWeatherModel = hourlyWeatherModel
    }
    convenience required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: HourlyWeatherCodingKeys.self)
        let houlryForecastArray = try container.decode([HourlyForecastData].self, forKey: .hourlyWeatherModel)
        let hourlyForecastList = List<HourlyForecastData>()
        hourlyForecastList.append(objectsIn: houlryForecastArray)
        try self.init(hourlyWeatherModel: hourlyForecastList)
    }
}
/*class Sections: Object, Codable {
    @objc dynamic var hourlyWeathe: HourlyForecastData = HourlyForecastData(timeDate: nil, time: 0, icon: "", temperature: 0.0 )
}*/
class HourlyForecastData: Object, Codable {
    @objc var timeDate: Date?
    @objc var time: Int = 0
    @objc var icon: String = ""
    @objc var temperature: Double = 0.0
    private enum HourlyCodingKeys : String, CodingKey {
        case time = "time"
        case icon = "icon"
        case temperature = "temperature"
    }
    convenience init(time: Int, icon: String, temperature: Double, timeDate: Date) throws {
        self.init()
        self.time = time
        self.timeDate = timeDate
        self.icon = icon
        self.temperature = temperature
    }
    convenience required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: HourlyCodingKeys.self)
        let time = try container.decode(Int.self, forKey: .time)
        let icon = try container.decode(String.self, forKey: .icon)
        let temperature = try container.decode(Double.self, forKey: .temperature)
        let timeDate = Date(timeIntervalSince1970: TimeInterval(time))
        try self.init(time: time, icon: icon, temperature: temperature, timeDate: timeDate)
    }
}














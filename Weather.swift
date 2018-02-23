//
//  Weather.swift
//  WeatherRx
//
//  Created by Jun Dang on 2017-09-25.
//  Copyright © 2017 Jun Dang. All rights reserved.
//

import Foundation

struct Weather {
    
    let cityName: String?
    let weatherSummary: String
    let icon: String?
    let time: Double
    let tempFarenheit: Double
    let maxTempFarenheit: Double
    let minTempFarenheit: Double
    let precipitationProbability: Double
    let precipitationIntensity: Double
    let dewPoint: Double
    let humidity: Double
    let windSpeedMPH: Double
    let windBearing: Double
    let sunriseTime: Double
    let sunsetTime: Double
    let cloudCover: Double
    
    
    
    var tempCelsius: Double {
        get {
            return (tempFarenheit - 32.0) * 5.0 / 9.0
        }
    }
    var maxTempCelsius: Double {
        get {
            return (maxTempFarenheit - 32.0) * 5.0 / 9.0
        }
    }
    var minTempCelsius: Double {
        get {
            return (minTempFarenheit - 32.0) * 5.0 / 9.0
        }
    }
    
    var windSpeedKPH: Double {
        get {
            return (windSpeedMPH * 1.609344 )
        }
    }
    
    
    var windDirection: String {
        get {
            var directions = ["N", "NNE", "NE", "ENE", "E", "ESE", "SE", "SSE",
                              "S", "SSW", "SW", "WSW", "W", "WNW", "NW", "NNW"]
            let i:Int = Int((windBearing + 11.25)/22.5)
            return String(directions[i % 16])
        }
    }
    
    
}

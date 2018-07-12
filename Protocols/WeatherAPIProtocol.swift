//
//  WeatherAPIProtocol.swift
//  WeatherRx
//
//  Created by Jun Dang on 2018-07-07.
//  Copyright © 2018 Jun Dang. All rights reserved.
//

import Foundation
import RxSwift


protocol WeatherAPIProtocol {
    //static func getWeatherObservable(lat: Double, lon: Double) -> Observable<WeatherForecastModel>
    static func getCurrentlyWeatherObservable(lat: Double, lon: Double) -> Observable<Result<CurrentlyWeatherModel, Error>>
    /*static func getHourlyWeatherObservable(lat: Double, lon: Double) -> Observable<HourlyWeatherModel>
    static func getDailyWeatherObservable(lat: Double, lon: Double) -> Observable<DailyWeatherModel>*/
}


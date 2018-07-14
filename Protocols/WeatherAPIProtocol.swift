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
    static func getWeatherObservable(lat: Double, lon: Double) -> Observable<Result<WeatherForecastModel, Error>>
}


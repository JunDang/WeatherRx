//
//  InternetServiceProtocol.swift
//  WeatherRx
//
//  Created by Jun Dang on 2018-07-25.
//  Copyright © 2018 Jun Dang. All rights reserved.
//

import Foundation
import RxSwift

protocol InternetServiceProtocol {
     static func searchImageURL(lat: Double, lon: Double) -> Observable<Result<NSURL, Error>>
     static func sendRequest(resultNSURL: Result<NSURL, Error>) -> Observable<Result<Data, Error>>
     static func getImage(resultNSURL: Result<NSURL, Error>, cache: ImageDataCachingProtocol.Type) -> Observable<Result<UIImage, Error>>
     static func getWeatherObservable(lat: Double, lon: Double) -> Observable<Result<WeatherForecastModel, Error>>
     static func locationGeocoding(address: String) -> Observable<Result<GeocodingModel, Error>>
     static func reverseGeocoding(lat: Double, lon: Double) -> Observable<Result<ReverseGeocodingModel, Error>>
}


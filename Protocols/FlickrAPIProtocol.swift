//
//  FlickrAPIProtocol.swift
//  WeatherRx
//
//  Created by Jun Dang on 2018-03-08.
//  Copyright © 2018 Jun Dang. All rights reserved.
//

import Foundation
import RxSwift


protocol FlickrAPIProtocol {
    static func searchImageURL(lat: Double, lon: Double, currentWeather:String) throws -> Observable <NSURL>
    static func createSearchParameters(lat: Double, lon: Double, currentWeather:String) -> Observable<[String:String]>
    static func sendRequest(to URL: NSURL) -> Observable<NSData>
    static func getImage(imageURL: NSURL, cache: ImageDataCachingProtocol.Type) -> Observable<UIImage?>
}

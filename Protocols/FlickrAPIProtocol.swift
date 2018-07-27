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
    static func searchImageURL(lat: Double, lon: Double) -> Observable<Result<NSURL, Error>>
    static func sendRequest(resultNSURL: Result<NSURL, Error>) -> Observable<Result<Data, Error>>
    static func getImage(resultNSURL: Result<NSURL, Error>, cache: ImageDataCachingProtocol.Type) -> Observable<Result<UIImage, Error>>
}



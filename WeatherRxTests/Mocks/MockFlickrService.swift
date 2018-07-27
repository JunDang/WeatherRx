//
//  MockFlickrService.swift
//  WeatherRxTests
//
//  Created by Jun Dang on 2018-04-25.
//  Copyright © 2018 Jun Dang. All rights reserved.
//

import Foundation
import XCTest
import Accounts

import RxSwift
import RxCocoa
import Unbox

@testable import WeatherRx

/*class MockFlickrService: FlickrAPIProtocol{
    
    static var flickrImageURL = PublishSubject<NSURL>()
    //static var flickrImage = PublishSubject<UIImage?>()
    static var flickrImageData = PublishSubject<NSData>()
    
    static func searchImageURL(lat: Double, lon: Double, currentWeather:String) -> Observable<NSURL> {
      return flickrImageURL.asObservable()
    }
    
    static func sendRequest(to imageURL: NSURL) -> Observable<NSData> {
      return flickrImageData.asObservable()
    }
 
    static func getImage(imageURL: NSURL, cache: ImageDataCachingProtocol.Type) -> Observable<UIImage?> {
      return self.sendRequest(to: imageURL)
        .map ({ flickrImageData in
        let flickrImage = UIImage(data: flickrImageData as Data)
        return flickrImage
        })
    }
}
*/

//
//  MockInternetService.swift
//  WeatherRx
//
//  Created by Jun Dang on 2018-09-05.
//  Copyright © 2018 Jun Dang. All rights reserved.
//

import XCTest
import Accounts
import RxSwift
import RxCocoa

@testable import WeatherRx

class MockInternetService: InternetServiceProtocol{
    static var imageURLResult = PublishSubject<Result<NSURL, Error>>()
    static var imageDataResult = PublishSubject<Result<Data, Error>>()
    static var imageResult = PublishSubject<Result<UIImage, Error>>()
    static var weatherForecastModelResult = PublishSubject<Result<WeatherForecastModel, Error>>()
    
    static func searchImageURL(lat: Double, lon: Double) -> Observable<Result<NSURL, Error>> {
        return imageURLResult.asObservable()
    }
    
    static func sendRequest(resultNSURL: Result<NSURL, Error>) -> Observable<Result<Data, Error>> {
        return imageDataResult.asObservable()
    }
    
    static func getImage(resultNSURL: Result<NSURL, Error>, cache: ImageDataCachingProtocol.Type) -> Observable<Result<UIImage, Error>> {
        switch resultNSURL {
        case .Success(let imageURL):
              return self.sendRequest(resultNSURL:resultNSURL)
                    .map() {(imageDataResult) in
                        switch imageDataResult {
                        case .Success(let imageData):
                            let imageFromRequest = UIImage(data: imageData as Data)
                            return Result<UIImage, Error>.Success(imageFromRequest!)
                        case .Failure(let error):
                            return Result<UIImage, Error>.Failure(error)
                        }
              }
        case .Failure(let error):
            return Observable.just(Result<UIImage, Error>.Failure(error))
        }
    }
    
    static func getWeatherObservable(lat: Double, lon: Double) -> Observable<Result<WeatherForecastModel, Error>> {
         return weatherForecastModelResult.asObservable()
    }
    
}

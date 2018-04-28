//
//  InternetAPI.swift
//  WeatherRx
//
//  Created by Jun Dang on 2018-04-25.
//  Copyright © 2018 Jun Dang. All rights reserved.
//

import Foundation
import RxSwift

class InternetAPI {
    //MARK: - compose url
    static func composeURL(from baseURL: String = "", parameters: [String:String] = [:]) -> URL {
        var components = URLComponents(string: baseURL)!
        components.queryItems = parameters.map(URLQueryItem.init)
        let url = try! components.asURL()
        return url
    }
    
    static func createFlickrSearchParameters(lat: Double, lon: Double, currentWeather:String) -> Observable<[String:String]> {
        return Observable.create { observer -> Disposable in
            if let urlEncodedcurrentWeather = currentWeather.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) {
                let parameters = [
                    "method": FlickrAPI.searchMethod,
                    "api_key": FlickrAPI.apiKey,
                    "format": "json",
                    "nojsoncallback": "1",
                    "per_page": "25",
                    "lat": "\(lat)",
                    "lon": "\(lon)",
                    "text": urlEncodedcurrentWeather,
                    "group_id": "92767609@N00",//"92767609@N00","1463451@N25"
                    "tagmode": "all"
                ]
                observer.onNext(parameters)
                observer.onCompleted()
            } else {
                observer.onError(FlickrService.flickrRequestError.URLCannotBeEncoded)
            }
            return Disposables.create()
        }
    }
}


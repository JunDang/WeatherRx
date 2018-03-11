//
//  FlickrService.swift
//  WeatherRx
//
//  Created by Jun Dang on 2017-09-29.
//  Copyright © 2017 Jun Dang. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import RxSwift
import RxCocoa
import Unbox
import RxAlamofire
import Alamofire


typealias JSONObject = [String: Any]


// MARK: -URL Components
struct FlickrAPI {
    static let baseURLString = "https://api.flickr.com/services/rest/"
    static let apiKey = "5a45bd8e5e5a3424a42246944f98d7fd"
    static let searchMethod = "flickr.photos.search"
}

struct FlickrService: FlickrAPIProtocol, InternetAPIProtocol {
      
   //MARK: - errors
    enum flickrRequestError: Error {
        case unknown
        case invalidJSONData
        case failedRequest
    }
    //MARK: - compose url
    static func composeURL(from baseURL: String = "", parameters: [String:String] = [:]) -> URL {
        var components = URLComponents(string: baseURL)!
        components.queryItems = parameters.map(URLQueryItem.init)
        let url = try! components.asURL()
        return url
    }
  
    static func searchImageURLAtLat(lat: Double, lon: Double, currentWeather:String) -> Observable <NSURL> {
        guard let urlEncodedcurrentWeather = currentWeather.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            return Observable.error(flickrRequestError.invalidJSONData)
        }
        let parameters = [
            "method": FlickrAPI.searchMethod,
            "api_key": FlickrAPI.apiKey,
            "format": "json",
            "nojsoncallback": "1",
            "per_page": "25",
            "lat": "\(lat)",
            "lon": "\(lon)",
            "text": urlEncodedcurrentWeather,
            "interestingness-desc&tags": "scenic,sea,lake,leaf,nature,colorful",
            "tagmode": "all"
        ]
        
        let flickrURL = FlickrService.composeURL(from: FlickrAPI.baseURLString, parameters: parameters)
        print("flickrURL: " + "\(flickrURL)")
        return RxAlamofire.requestJSON(.get, flickrURL)
            .map ({ (response, json) in
                guard let dict = json as? JSONObject else {
                    throw flickrRequestError.invalidJSONData
                }
                let flickrPhotoResult: FlickrPhotoResult = try unbox(dictionary: dict)
                let flickrPhotos = flickrPhotoResult.flickrPhotoResult!.flickrPhotos
                let randomIndex = Int(arc4random_uniform(UInt32(flickrPhotos.count)))
                let photo = flickrPhotos[randomIndex]
                let imageURL = photo.createImageURL()
                print("imageURL: " + "\(imageURL)")
                return imageURL
            })
   }
  
    static func sendRequest(to imageURL: NSURL) -> Observable<UIImage> {
        let request = URLRequest(url: imageURL as URL)
        return RxAlamofire
            .requestData(request)
            .catchError { error in
                return Observable.never()
        }
       .map{ (response, data) -> UIImage in
       let image = UIImage(data: data)
       return image!
      }
   }
    
 }

    
                        
                        
    
           
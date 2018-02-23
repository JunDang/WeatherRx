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
import UnboxedAlamofire

struct FlickrAPI {
    static let baseURLString = "https://api.flickr.com/services/rest/"
    static let apiKey = "5a45bd8e5e5a3424a42246944f98d7fd"
    static let searchMethod = "flickr.photos.search"
}

enum flickrRequestError: Error {
    case unknown
    case invalidJSONData
    case failedRequest
 }

typealias FlickrImageCompletionHandler = ([FlickrPhoto]?, flickrRequestError?) -> Void
//typealias FlickrImageCompletionHandler = (UIImage?) -> Void

class FlickrService {
    var lat: String = "43.6532"
    var lon: String = "-79.3832"
    var currentWeather: String = "sunny"
    let apiType: InternetAPIProtocol.Type
    init(lat: String, lon: String, currentWeather: String, apiType: InternetAPIProtocol.Type = InternetAPI.self) {
        self.apiType = apiType
        self.lat = lat
        self.lon = lon
        self.currentWeather = currentWeather
        retrieveImageAtLat(lat: lat, lon: lon, currentWeather: currentWeather) {flickrPhotos, error  in
            guard let flickrPhotos = flickrPhotos else { return }
            if let error = error {
                print("Unable to forward photos (\(error))")
            }
            //self.render(image: image)
            return
            
        }
    }

    func retrieveImageAtLat(lat: String, lon: String, currentWeather:String, completion: @escaping FlickrImageCompletionHandler) {
        guard let urlEncodedcurrentWeather = currentWeather.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            completion(nil, .failedRequest)
            return
        }
     
        let parameters = [
            "method": FlickrAPI.searchMethod,
            "format": "json",
            "nojsoncallback": "1",
            "api_key": FlickrAPI.apiKey,
            "per_page": "25",
            "lat": lat,
            "lon": lon,
            "text": urlEncodedcurrentWeather,
            "interestingness-desc&tags": "scenic,landscape,flower,tree,nature,insects,water,sea,cloud,leaf,colorful",
            "tagmode": "all"
        ]
        let url = InternetAPI.composeURL(from: FlickrAPI.baseURLString, parameters: parameters)
        print(url)
        Alamofire.request(url, method: .get).responseObject { (response: DataResponse<FlickrPhotoResult>) in
            // handle response
            let flickrPhotoResult = response.result.value
            let flickrPhotos = flickrPhotoResult?.flickrPhotoResult!.flickrPhotos
            let randomIndex = Int(arc4random_uniform(UInt32(flickrPhotos!.count)))
            let photo = flickrPhotos![randomIndex]
            let imageURL = photo.createImageURL()
            print(imageURL)
            // handle error
            if let error = response.result.error as? UnboxedAlamofireError {
                print("error: \(error.description)")
            }
        }
        
    }
        
}

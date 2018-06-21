//
//  FlickrService.swift
//  WeatherRx
//
//  Created by Jun Dang on 2017-09-29.
//  Copyright © 2017 Jun Dang. All rights reserved.
//

/*import Foundation
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

struct FlickrService: FlickrAPIProtocol {
    
    //MARK: - errors
    enum flickrRequestError: Error {
        case unknown
        case invalidJSONData
        case failedRequest
        case URLCannotBeEncoded
        case emptyAlbum
        case imageNotExist
    }
    
    /* static func searchImageURL(lat: Double, lon: Double, currentWeather:String) -> Observable<NSURL> {
     return InternetAPI.createFlickrSearchParameters(lat: lat, lon: lon, currentWeather:currentWeather)
     .flatMap ({ parameters -> Observable<NSURL> in
     let flickrURL = InternetAPI.composeURL(from: FlickrAPI.baseURLString, parameters: parameters)
     print("flickrURL: " + "\(flickrURL)")
     return RxAlamofire.requestJSON(.get, flickrURL)
     .map ({ (response, json) in
     guard let dict = json as? JSONObject else {
     throw flickrRequestError.invalidJSONData
     }
     print("flickrResponse: " + "\(response)")
     print("dict: " + "\(dict)")
     let flickrPhotoResult: FlickrPhotoResult = try unbox(dictionary: dict)
     let flickrPhotos = flickrPhotoResult.flickrPhotoResult!.flickrPhotos
     guard flickrPhotos.count > 0 else {
     throw flickrRequestError.emptyAlbum
     }
     let randomIndex = Int(arc4random_uniform(UInt32(flickrPhotos.count)))
     let photo = flickrPhotos[randomIndex]
     let imageURL = photo.createImageURL()
     print("imageURL: " + "\(imageURL)")
     return imageURL
     })
     })
     }*/
    static private func request<T: Any>(url: URL, parameters: [String: String] = [:]) -> Observable<T> {
        return Observable.create { observer in
            var comps = URLComponents(string: url.absoluteString)!
            comps.queryItems = parameters.map(URLQueryItem.init)
            let url = try! comps.asURL()
            
            let request = Alamofire.request(url.absoluteString,
                                            method: .get,
                                            parameters: Parameters(),
                                            encoding: URLEncoding.httpBody,
                                            headers: ["Authorization": "Bearer \(token)"])
            request.responseJSON { response in
                guard response.error == nil, let data = response.data,
                    let json = try? JSONSerialization.jsonObject(with: data, options: []) as? T, let result = json else {
                        observer.onError(Errors.requestFailed)
                        return
                }
                observer.onNext(result)
                observer.onCompleted()
            }
            
            return Disposables.create {
                request.cancel()
            }
        }
    }
    static func searchImageURL(lat: Double, lon: Double, currentWeather:String) -> Observable<NSURL> {
        return InternetAPI.createFlickrSearchParameters(lat: lat, lon: lon, currentWeather:currentWeather).flatMap ({ parameters -> Observable<NSURL> in
            let flickrURL = InternetAPI.composeURL(from: FlickrAPI.baseURLString, parameters: parameters)
            print("flickrURL: " + "\(flickrURL)")
            return RxAlamofire.requestJSON(.get, flickrURL)
                .map(handleFlickrURLResponse)
        })
    }
    static func handleFlickrURLResponse(result: (HTTPURLResponse, Any))throws -> NSURL {
        print("handleResponse: " + "\(result.1)")
        guard let dict = result.1 as? JSONObject else {
            throw flickrRequestError.invalidJSONData
        }
        print("dict: " + "\(dict)")
        let flickrPhotoResult: FlickrPhotoResult = try unbox(dictionary: dict)
        let flickrPhotos = flickrPhotoResult.flickrPhotoResult!.flickrPhotos
        guard flickrPhotos.count > 0 else {
            throw flickrRequestError.emptyAlbum
        }
        let randomIndex = Int(arc4random_uniform(UInt32(flickrPhotos.count)))
        let photo = flickrPhotos[randomIndex]
        let imageURL = photo.createImageURL()
        print("imageURL: " + "\(imageURL)")
        return imageURL
    }
    
    static func sendRequest(to imageURL: NSURL) -> Observable<NSData> {
        let request = URLRequest(url: imageURL as URL)
        return RxAlamofire
            .requestData(request)
            .catchError { error in
                print(error)
                return Observable.never()
            }
            .map{ (response, data) in
                print("response: " + "\(response)")
                print("dataYYY: " + "\(data)")
                if data.count < 5000 {
                    let banffData = UIImagePNGRepresentation(UIImage(named: "banff")!)
                    return banffData! as NSData
                } else {
                    //print("data: " + "\(data)")
                    return data as NSData
                }
        }
    }
    
    static func getImage(imageURL: NSURL, cache: ImageDataCachingProtocol.Type) -> Observable<UIImage?> {
        if let imageDataFromCache = cache.imageDataFromURLFromChache(url: imageURL) {
            let imageFromCache = UIImage(data: imageDataFromCache as Data)
            return Observable.just(imageFromCache)
        } else {
            return self.sendRequest(to: imageURL)
                .do(onNext: { (imageDataFromRequest) in
                    cache.saveImageDataToCache(data: imageDataFromRequest, url: imageURL)
                }, onError: { e in
                    print("errorViewModel: " + "\(e)")
                })
                .map ({ imageDataFromRequest in
                    let imageFromRequest = UIImage(data: imageDataFromRequest as Data)
                    return imageFromRequest
                })
        }
    }
    
}*/







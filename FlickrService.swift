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
        case URLCannotBeEncoded
        case emptyAlbum
        case imageNotExist
    }
    //MARK: - compose url
    static func composeURL(from baseURL: String = "", parameters: [String:String] = [:]) -> URL {
        var components = URLComponents(string: baseURL)!
        components.queryItems = parameters.map(URLQueryItem.init)
        let url = try! components.asURL()
        return url
    }
    static func createSearchParameters(lat: Double, lon: Double, currentWeather:String) -> Observable<[String:String]> {
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
                    //"accuracy": "11",
                    //"sort": "scenic,landscape,flower,tree,nature,insects,water,sea,cloud,leaf,colorful",
                    "group_id": "92767609@N00",//"92767609@N00", "1463451@N25"
                    "tagmode": "all"
                ]
                observer.onNext(parameters)
                observer.onCompleted()
               } else {
                observer.onError(flickrRequestError.URLCannotBeEncoded)
            }
            return Disposables.create()
         }
    }
    
    static func searchImageURL(lat: Double, lon: Double, currentWeather:String) -> Observable<NSURL> {
       
        return createSearchParameters(lat: lat, lon: lon, currentWeather:currentWeather).flatMap ({ parameters -> Observable<NSURL> in
            let flickrURL = FlickrService.composeURL(from: FlickrAPI.baseURLString, parameters: parameters)
            print("flickrURL: " + "\(flickrURL)")
            return RxAlamofire.requestJSON(.get, flickrURL)
                .map ({ (response, json) in
                    guard let dict = json as? JSONObject else {
                        throw flickrRequestError.invalidJSONData
                    }
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
     }
    
 
   /* static func searchImageURLAtLatLng(parameters: [String: String]) -> Observable <NSURL> {
        let flickrURL = FlickrService.composeURL(from: FlickrAPI.baseURLString, parameters: parameters)
        print("flickrURL: " + "\(flickrURL)")
        return RxAlamofire.requestJSON(.get, flickrURL)
            .map ({ (response, json) in
                guard let dict = json as? JSONObject else {
                    throw flickrRequestError.invalidJSONData
                }
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
    }*/
   /* static func sendRequest(to imageURL: NSURL) -> Observable<UIImage> {
        let request = URLRequest(url: imageURL as URL)
        return RxAlamofire
            .requestData(request)
            .catchError { error in
                return Observable.never()
        }
       .map{ (response, data) -> UIImage in
        print("dataCount: " + "\(data.count)")
        guard data.count > 3000 else {
            throw flickrRequestError.imageNotExist
        }
        let image = UIImage(data: data)
        return image!
      }
   }*/
   static func sendRequest(to imageURL: NSURL) -> Observable<NSData> {
        let request = URLRequest(url: imageURL as URL)
        return RxAlamofire
            .requestData(request)
            .catchError { error in
                return Observable.never()
            }
            .map{ (response, data) in
               if data.count < 5000 {
                 let banffData = UIImagePNGRepresentation(UIImage(named: "banff")!)
                 print("banffdata: " + "\(String(describing: banffData))")
                 return banffData! as NSData
                } else {
                 print("data: " + "\(data)")
                 return data as NSData
                }
                
        }
    }
   /* static func sendRequest(to imageURL: NSURL) -> Observable<UIImage> {
        let request = URLRequest(url: imageURL as URL)
        return RxAlamofire
            .requestData(request)
            .catchError { error in
                return Observable.never()
            }
            .filter {(response, data) in
                data.count > 5000
            }
            .map{ (response, data) -> UIImage in
                print("dataCount: " + "\(data.count)")
                let image = UIImage(data: data)
                return image!
        }
    }*/
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
    
 }

    
                        
                        
    
           

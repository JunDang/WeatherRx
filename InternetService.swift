//
//  InternetService.swift
//  WeatherRx
//
//  Created by Jun Dang on 2018-06-06.
//  Copyright © 2018 Jun Dang. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa




enum Result<T, Error> {
    case Success(T)
    case Failure(Error)
}
// MARK: -URL Components
struct FlickrAPI {
    static let baseURLString = "https://api.flickr.com/services/rest/"
    static let apiKey = "5a45bd8e5e5a3424a42246944f98d7fd"
    static let searchMethod = "flickr.photos.search"
}

enum flickrRequestError: Error {
    case unknown
    case failedRequest
    case URLCannotBeEncoded
    case emptyAlbum
    case imageNotExist
}

struct DarskyAPI {
    static let baseURLString = "https://api.forecast.io/forecast/"
    static let apiKey = "03d4359e5f3bcc9a216e2900ebea8130"
}


class InternetService: FlickrAPIProtocol {
    static let defaultSession = URLSession(configuration: .default)
    static var dataTask: URLSessionDataTask?
    
    static func searchImageURL(lat: Double, lon: Double, currentWeather:String) -> Observable<NSURL> {
         return Observable.create {observer -> Disposable in 
            let baseURLString = FlickrAPI.baseURLString
            guard let urlEncodedcurrentWeather = currentWeather.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
               observer.onError(flickrRequestError.URLCannotBeEncoded)
               return Disposables.create()
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
                "group_id": "92767609@N00",//"92767609@N00","1463451@N25"
                "tagmode": "all"
            ]
        
            let result  = request(baseURLString, parameters: parameters)
            switch result {
                case let .Success(data):
                   let flickrModel = try? JSONDecoder().decode(FlickrModel.self, from: data)
                   let flickrPhotos = flickrModel!.flickrResult!.flickrPhotos
                   guard flickrPhotos.count > 0 else {
                    observer.onError(flickrRequestError.emptyAlbum)
                    return Disposables.create()
                   }
                   let randomIndex = Int(arc4random_uniform(UInt32(flickrPhotos.count)))
                   let photo = flickrPhotos[randomIndex]
                   let imageURL = photo.createImageURL()
                   observer.onNext(imageURL)
                   observer.onCompleted()
                case let .Failure(error):
                   observer.onError(error)
                }
            return Disposables.create()
       }
  }
            
    static func sendRequest(to imageURL: NSURL) -> Observable<NSData> {
        return Observable.create {observer -> Disposable in
            let baseURLString = imageURL.absoluteString
            let parameters: [String: String] = [:]
            var imageData: Data?
            let result  = request(baseURLString!, parameters: parameters)
            switch result {
            case let .Success(data):
                if data.count < 5000 {
                  imageData = UIImagePNGRepresentation(UIImage(named: "banff")!)
                }
                imageData = data
                let imageNSData = imageData! as NSData
                observer.onNext(imageNSData)
                observer.onCompleted()
            case let .Failure(error):
                observer.onError(error)
            }
            return Disposables.create()
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
// MARK: - URL request
    static private func request(_ baseURL: String = "", parameters: [String: String] = [:]) -> Result<Data, Error> {
        dataTask?.cancel()
        var components = URLComponents(string: baseURL)!
        components.queryItems = parameters.map(URLQueryItem.init)
        let url = components.url!
        print("url: " + "\(String(describing: url))")
        let urlRequest = URLRequest(url: url)
        
        var result: Result<Data, Error>?
        dataTask = defaultSession.dataTask(with: urlRequest) { data, response, error in
            defer { self.dataTask = nil }
            print("data: " + "\(String(describing: data))")
            print("error: " + "\(String(describing: error))")
            if let error = error {
                print("error")
               result = Result<Data, Error>.Failure(error)
            } else if let data = data, let response = response as? HTTPURLResponse, 200 ..< 300 ~= response.statusCode {
                print("data")
               result = Result<Data, Error>.Success(data)
                print("result: " + "\(String(describing: result))")
            }
          self.dataTask?.resume()
       }
       return result!
    }

}

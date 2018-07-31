//
//  InternetService2.swift
//  WeatherRx
//
//  Created by Jun Dang on 2018-07-31.
//  Copyright © 2018 Jun Dang. All rights reserved.
//

/*import Foundation
import RxSwift
import RxCocoa
import CoreLocation

enum Result<T, Error> {
    case Success(T)
    case Failure(Error)
}
// MARK: -Flickr URL Components
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

enum geocodingError: Error {
    case unknown
    case locationNotFound
    case URLCannotBeEncoded
}
//MARK: -Weather URL Components
struct DarskyAPI {
    static let baseURLString = "https://api.forecast.io/forecast/"
    static let apiKey = "03d4359e5f3bcc9a216e2900ebea8130"
}

//MARK: -Geocoding URL Components
struct GoogleGeocodingAPI {
    static let baseURLString = "https://maps.googleapis.com/maps/api/geocode/json?"
    static let apiKey = "AIzaSyBdTOGf2Apyxjck8RxFk2ffcYTnGU7btk8"
}
//MARK: -ReverseGeocoding URL Components
struct ReverseGeocodingAPI {
    static let baseURLString = "https://maps.googleapis.com/maps/api/geocode/json?"
    static let apiKey = "AIzaSyBdTOGf2Apyxjck8RxFk2ffcYTnGU7btk8"
}
class InternetService: InternetServiceProtocol {
    static var defaultSession = URLSession(configuration: .default)
    //static var dataTask: URLSessionDataTask?
    
    //MARK: - Flickr
    static func searchImageURL(lat: Double, lon: Double) -> Observable<Result<NSURL, Error>> {
        
        let baseURLString = FlickrAPI.baseURLString
        let parameters = [
            "method": FlickrAPI.searchMethod,
            "api_key": FlickrAPI.apiKey,
            "format": "json",
            "nojsoncallback": "1",
            "per_page": "25",
            "lat": "\(lat)",
            "lon": "\(lon)",
            "group_id": "92767609@N00",//"92767609@N00","1463451@N25"
            "tagmode": "all"
        ]
        return request(baseURLString, parameters: parameters)
            .map({ result in
                switch result {
                case .Success(let data):
                    var flickrModel: FlickrModel?
                    do {
                        flickrModel = try JSONDecoder().decode(FlickrModel.self, from: data)
                    } catch let parseError {
                        print("parseError: " + "\(parseError)")
                    }
                    //print("flickrModel: " + "\(String(describing: flickrModel))")
                    let flickrPhotos = flickrModel!.flickrModel!.flickrPhotos
                    guard flickrPhotos.count > 0 else {
                        return Result<NSURL, Error>.Failure(flickrRequestError.emptyAlbum)
                    }
                    let randomIndex = Int(arc4random_uniform(UInt32(flickrPhotos.count)))
                    let photo = flickrPhotos[randomIndex]
                    let imageURL = photo.createImageURL()
                    return Result<NSURL, Error>.Success(imageURL)
                case .Failure(let error):
                    return Result<NSURL, Error>.Failure(error)
                }
            })
    }
    
    static func sendRequest(resultNSURL: Result<NSURL, Error>) -> Observable<Result<Data, Error>> {
        switch resultNSURL {
        case .Success(let imageURL):
            let baseURLString = imageURL.absoluteString
            let parameters: [String: String] = [:]
            var imageData: Data?
            return request(baseURLString!, parameters: parameters)
                .map({ result in
                    switch result {
                    case .Success(let data):
                        if data.count < 8000 {
                            imageData = UIImagePNGRepresentation(UIImage(named: "banff")!)
                        }
                        imageData = data
                        return Result<Data, Error>.Success(imageData!)
                    case .Failure(let error):
                        return Result<Data, Error>.Failure(error)
                    }
                })
        case .Failure(let error):
            return Observable.just(Result<Data, Error>.Failure(error))
        }
        
    }
    static func getImage(resultNSURL: Result<NSURL, Error>, cache: ImageDataCachingProtocol.Type) -> Observable<Result<UIImage, Error>> {
        switch resultNSURL {
        case .Success(let imageURL):
            if let imageDataFromCache = cache.imageDataFromURLFromChache(url: imageURL) {
                let imageFromCache = UIImage(data: imageDataFromCache as Data)
                return Observable.just(Result<UIImage, Error>.Success(imageFromCache!))
            } else {
                return self.sendRequest(resultNSURL:resultNSURL)
                    .map() {(imageDataResult) in
                        switch imageDataResult {
                        case .Success(let imageData):
                            cache.saveImageDataToCache(data: imageData as NSData, url: imageURL)
                            let imageFromRequest = UIImage(data: imageData as Data)
                            return Result<UIImage, Error>.Success(imageFromRequest!)
                        case .Failure(let error):
                            return Result<UIImage, Error>.Failure(error)
                        }
                }
            }
        case .Failure(let error):
            return Observable.just(Result<UIImage, Error>.Failure(error))
        }
    }
    
    // MARK: - Weather
    static func getWeatherObservable(lat: Double, lon: Double) -> Observable<Result<WeatherForecastModel, Error>> {
        var baseURL = URL(string: DarskyAPI.baseURLString)!
        baseURL.appendPathComponent(DarskyAPI.apiKey)
        baseURL.appendPathComponent("\(lat),\(lon)")
        // print("baseURL: " + "\(baseURL)")
        let parameters: [String: String] = [:]
        return request(baseURL.absoluteString, parameters: parameters)
            .map({result in
                switch result {
                case .Success(let data):
                    var weatherForecastModel: WeatherForecastModel?
                    do {
                        weatherForecastModel = try JSONDecoder().decode(WeatherForecastModel.self, from: data)
                    } catch let parseError {
                        print("parseError: " + "\(parseError)")
                    }
                    return Result<WeatherForecastModel, Error>.Success(weatherForecastModel!)
                case .Failure(let error):
                    return Result<WeatherForecastModel, Error>.Failure(error)
                }
            })
    }
    /*  //MARK: -Geocoding
     static func locationGeocoding(address: String) -> Observable<Result<GeocodingModel, Error>> {
     let address = address.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
     let baseURL = URL(string: GoogleGeocodingAPI.baseURLString)!
     let parameters = [
     "key": GoogleGeocodingAPI.apiKey,
     "address": "\(String(describing: address))"
     ]
     return request(baseURL.absoluteString, parameters: parameters)
     .map({result in
     switch result {
     case .Success(let data):
     var geocodingModel: GeocodingModel?
     do {
     geocodingModel = try JSONDecoder().decode(GeocodingModel.self, from: data)
     } catch let parseError {
     print("parseError: " + "\(parseError)")
     }
     //print(" geocodingModel: " + "\(String(describing:  geocodingModel))")
     return Result<GeocodingModel, Error>.Success(geocodingModel!)
     case .Failure(let error):
     return Result<GeocodingModel, Error>.Failure(error)
     }
     })
     
     }
     //MARK: - reverse geocoding
     static func reverseGeocoding(lat: Double, lon: Double) -> Observable<Result<ReverseGeocodingModel, Error>> {
     var baseURL = URL(string: ReverseGeocodingAPI.baseURLString)!
     let parameters = [
     "key": ReverseGeocodingAPI.apiKey,
     "latlng": "\(lat)" + "," + "\(lon)"
     ]
     return request(baseURL.absoluteString, parameters: parameters)
     .map({result in
     switch result {
     case .Success(let data):
     var reverseGeocodingModel: ReverseGeocodingModel?
     do {
     reverseGeocodingModel = try JSONDecoder().decode(ReverseGeocodingModel.self, from: data)
     } catch let parseError {
     print("parseError: " + "\(parseError)")
     }
     //let address = reverseGeocodingModel?.reverseGeocodingResults[0].address
     print(" reverseGeocodingModel: " + "\(String(describing:  reverseGeocodingModel?.reverseGeocodingResults[0].address))")
     return Result<ReverseGeocodingModel, Error>.Success(reverseGeocodingModel!)
     case .Failure(let error):
     return Result<ReverseGeocodingModel, Error>.Failure(error)
     }
     })
     
     }*/
    
    //MARK: - URL request
    static private func request(_ baseURL: String = "", parameters: [String: String] = [:]) -> Observable<Result<Data, Error>> {
        //var defaultSession = URLSession(configuration: .default)
        var dataTask: URLSessionDataTask?
        dataTask?.cancel()
        return Observable.create { observer in
            var components = URLComponents(string: baseURL)!
            components.queryItems = parameters.map(URLQueryItem.init)
            let url = components.url!
            print("url: " + "\(String(describing: url))")
            var result: Result<Data, Error>?
            dataTask = defaultSession.dataTask(with: url) { data, response, error in
                //defer { dataTask = nil }
                if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
                    result = Result<Data, Error>.Success(data)
                } else {
                    if let error = error {
                        result = Result<Data, Error>.Failure(error)
                    }
                }
                observer.onNext(result!)
                observer.onCompleted()
            }
            dataTask?.resume()
            return Disposables.create {
                dataTask?.cancel()
            }
        }
    }
}
*/

//
//  InternetService3.swift
//  WeatherRx
//
//  Created by Jun Dang on 2018-07-26.
//  Copyright © 2018 Jun Dang. All rights reserved.
//

import Foundation
import Foundation
import RxSwift
import RxCocoa

/*enum Result<T, Error> {
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

class InternetService: InternetServiceProtocol {
    //static var defaultSession = URLSession(configuration: .default)
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
        return request(baseURLString, parameters: parameters as! [String : String])
            .map({ result in
                switch result {
                case .Success(let data):
                    var photoModel: PhotoModel?
                    do {
                        photoModel = try JSONDecoder().decode(PhotoModel.self, from: data)
                    } catch let parseError {
                        print("parseError: " + "\(parseError)")
                    }
                    print("photoModel: " + "\(String(describing: photoModel))")
                    let photos = photoModel!.photoModel!.photos
                    guard photos.count > 0 else {
                        throw flickrRequestError.emptyAlbum
                    }
                    let randomIndex = Int(arc4random_uniform(UInt32(photos.count)))
                    let photo = photos[randomIndex]
                    let imageURL = photo.createImageURL()
                    return Result<NSURL, Error>.Success(imageURL)
                case .Failure(let error):
                    return Result<NSURL, Error>.Failure(error)
                }
            })
    }
    
    static func sendRequest(resultNSURL: Result<NSURL, Error>) -> Observable<Result<UIImage, Error>> {
        switch resultNSURL {
        case .Success(let imageURL):
            let baseURLString = imageURL.absoluteString
            let parameters: [String: String] = [:]
            var image: UIImage?
            return request(baseURLString!, parameters: parameters)
                .map({ result in
                    switch result {
                    case let .Success(data):
                        if data.count < 8000 {
                            image = UIImage(named: "banff")!
                        }
                        image = UIImage(data: data)
                        return Result<UIImage, Error>.Success(image!)
                    case let .Failure(error):
                        return Result<UIImage, Error>.Failure(error)
                    }
                })
        case .Failure(let error):
            return Observable.just(Result<UIImage, Error>.Failure(error))
        }
        
    }
    /*static func sendRequest(to imageURL: NSURL) -> Observable<Result<UIImage, Error>> {
     let baseURLString = imageURL.absoluteString
     let parameters: [String: String] = [:]
     var image: UIImage?
     return request(baseURLString!, parameters: parameters)
     .map({ result in
     switch result {
     case let .Success(data):
     if data.count < 8000 {
     image = UIImage(named: "banff")!
     }
     image = UIImage(data: data)
     return Result<UIImage, Error>.Success(image!)
     case let .Failure(error):
     return Result<UIImage, Error>.Failure(error)
     }
     })
     }
     
     static func getImage(imageURL: NSURL) -> Observable<Result<UIImage, Error>> {
     return self.sendRequest(to: imageURL)
     }*/
    // MARK: - Weather
    static func getWeatherObservable(lat: Double, lon: Double) -> Observable<Result<WeatherForecastModel, Error>> {
        print("weatherfunctioncalled")
        var baseURL = URL(string: DarskyAPI.baseURLString)!
        baseURL.appendPathComponent(DarskyAPI.apiKey)
        baseURL.appendPathComponent("\(lat),\(lon)")
        print("baseURL: " + "\(baseURL)")
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
                    //let currentlyWeather = weatherForecastModel?.currently
                    //print("currentlyWeather: " + "\(String(describing: currentlyWeather))")
                    //print("weatherForecastModel: " + "\(String(describing: weatherForecastModel))")
                    return Result<WeatherForecastModel, Error>.Success(weatherForecastModel!)
                case .Failure(let error):
                    //print("error: " + "\(String(describing: error))")
                    //throw error
                    return Result<WeatherForecastModel, Error>.Failure(error)
                }
            })
    }
    
    //MARK: - URL request
    static private func request(_ baseURL: String = "", parameters: [String: String] = [:]) -> Observable<Result<Data, Error>> {
        var defaultSession = URLSession(configuration: .default)
        var dataTask: URLSessionDataTask?
        dataTask?.cancel()
        return Observable.create { observer in
            print("observableblockcalled")
            var components = URLComponents(string: baseURL)!
            components.queryItems = parameters.map(URLQueryItem.init)
            let url = components.url!
            print("url: " + "\(String(describing: url))")
            
            var result: Result<Data, Error>?
            dataTask = defaultSession.dataTask(with: url) { data, response, error in
                defer { /*self.*/dataTask = nil }
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
            //print("taskresume")
            return Disposables.create {
                dataTask?.cancel()
            }
        }
    }
    /* static private func request(_ baseURL: String = "", parameters: [String: String] = [:]) -> Observable<Result<Data, Error>> {
     //print("requestfunctioncalled")
     // print("baseURLinrequest " + "\(baseURL)")
     dataTask?.cancel()
     return Observable.create { observer in
     print("observableblockcalled")
     var components = URLComponents(string: baseURL)!
     components.queryItems = parameters.map(URLQueryItem.init)
     let url = components.url!
     print("url: " + "\(String(describing: url))")
     
     var result: Result<Data, Error>?
     dataTask = defaultSession.dataTask(with: url) { data, response, error in
     defer { self.dataTask = nil }
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
     //print("taskresume")
     return Disposables.create {
     dataTask?.cancel()
     }
     }
     }*/
}*/

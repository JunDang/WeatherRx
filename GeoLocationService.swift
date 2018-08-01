//
//  GeoLocationService.swift
//  WeatherRx
//
//  Created by Jun Dang on 2018-07-22.
//  Copyright © 2018 Jun Dang. All rights reserved.
//

import Foundation
import CoreLocation
import RxCocoa
import RxSwift

class GeoLocationService {
    static let instance = GeoLocationService()
    private (set) var location: Driver<CLLocationCoordinate2D>
    private let locationManager = CLLocationManager()
    var geoLocation: Observable<Result<CLLocationCoordinate2D, Error>>?
 
    private init() {
        locationManager.distanceFilter = kCLDistanceFilterNone;
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
       
        location = locationManager.rx.didUpdateLocations
            .asDriver(onErrorJustReturn: [])
            .filter { $0.count > 0 }
            .map { $0.last!.coordinate }
            .throttle(0.5)
            .distinctUntilChanged({ (lhs, rhs) -> Bool in
                fabs(lhs.latitude - rhs.latitude) <= 0.0000001 && fabs(lhs.longitude - rhs.longitude) <= 0.0000001
            })
        
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    func getLocation() -> Driver<CLLocationCoordinate2D> {
        return location
    }
    func locationGeocoding(address: String) -> Observable<Result<CLLocationCoordinate2D, Error>> {
        let address = address.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        let baseURL = URL(string: GoogleGeocodingAPI.baseURLString)!
        let parameters = [
            "key": GoogleGeocodingAPI.apiKey,
            "address": "\(String(describing: address!))"
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
                    guard geocodingModel!.geocodingResults.count > 0 else {
                        let lat = 0.0
                        let lon = 0.0
                        let fakedGeoLocation = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                        return Result<CLLocationCoordinate2D, Error>.Success(fakedGeoLocation)
                    }
                    let lat = geocodingModel!.geocodingResults[0].geometry?.location?.lat
                    let lon = geocodingModel!.geocodingResults[0].geometry?.location?.lon
                    let geoLocation = CLLocationCoordinate2D(latitude: lat!, longitude: lon!)
                    return Result<CLLocationCoordinate2D, Error>.Success(geoLocation)
                  case .Failure(let error):
                    return Result<CLLocationCoordinate2D, Error>.Failure(error)
                }
            })
    }
    
    //MARK: - URL request
    private func request(_ baseURL: String = "", parameters: [String: String] = [:]) -> Observable<Result<Data, Error>> {
        let defaultSession = URLSession(configuration: .default)
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

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
    private (set) var locationObservable: Observable<CLLocationCoordinate2D>
    private let locationManager = CLLocationManager()
    var geoLocation: Observable<Result<(CLLocationCoordinate2D, String), Error>>?
    var cityResultObservable: Observable<Result<String, Error>>?
    var cityName: String?
    private let bag = DisposeBag()
 
    private init() {
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
       
        locationObservable = locationManager.rx.didUpdateLocations
                  .catchErrorJustReturn([])
                  .filter { $0.count > 0 }
                  .map { $0.last!.coordinate }
                  .throttle(0.5, scheduler: MainScheduler.instance)
                  .distinctUntilChanged({ (lhs, rhs) -> Bool in
                        fabs(lhs.latitude - rhs.latitude) <= 0.0000001 && fabs(lhs.longitude - rhs.longitude) <= 0.0000001
                  })
        
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        cityResultObservable = locationObservable
            .flatMap() {location -> Observable<Result<String, Error>> in
                let lat = location.latitude
                let lon = location.longitude
                return self.reverseGeocoding(lat: lat, lon: lon)
        }
    }
    func getLocation() -> Observable<CLLocationCoordinate2D> {
        return locationObservable
    }
    func locationGeocoding(address: String) -> Observable<Result<(CLLocationCoordinate2D, String), Error>> {
        let baseURL = URL(string: GoogleGeocodingAPI.baseURLString)!
        let parameters = [
            "key": GoogleGeocodingAPI.apiKey,
            "address": address
        ]
        var cityName: String = ""
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
                        return Result<(CLLocationCoordinate2D, String), Error>.Failure(geocodingError.locationNotFound)
                    }
                    let lat = geocodingModel!.geocodingResults[0].geometry?.location?.lat
                    let lon = geocodingModel!.geocodingResults[0].geometry?.location?.lon
                    let geoLocation = CLLocationCoordinate2D(latitude: lat!, longitude: lon!)
                    let addressComponents = geocodingModel!.geocodingResults[0].addressComponents
                    print("addressComponents: \(addressComponents)")
                    let addressComponentsLocality = addressComponents.filter{$0.types.contains("locality")}
                    print("addressComponentsLocality: \(addressComponentsLocality)")
                    let addressComponentsNeighborhood = addressComponents.filter{$0.types.contains("neighborhood")}
                    print("addressComponentsNeighborhood: \(addressComponentsNeighborhood)")
                    if addressComponentsNeighborhood.count > 0 {
                       cityName = addressComponentsNeighborhood[0].longName
                    } else if addressComponentsLocality.count > 0 {
                       cityName = addressComponentsLocality[0].longName
                    } else {
                       cityName = addressComponents[0].longName
                    }
                    return Result<(CLLocationCoordinate2D, String), Error>.Success((geoLocation, cityName))
                case .Failure(let error):
                    return Result<(CLLocationCoordinate2D, String), Error>.Failure(error)
                }
            })
    }
    
    //MARK: - reverse geocoding
    func reverseGeocoding(lat: Double, lon: Double) -> Observable<Result<String, Error>> {
        let baseURL = URL(string: ReverseGeocodingAPI.baseURLString)!
        let parameters = [
            "key": ReverseGeocodingAPI.apiKey,
            "latlng": "\(lat)" + "," + "\(lon)"
        ]
        var cityName: String = ""
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
                    guard reverseGeocodingModel!.reverseGeocodingResults.count > 0 else {
                        return Result<String, Error>.Failure(geocodingError.locationNotFound)
                    }
                    let addressComponents = reverseGeocodingModel!.reverseGeocodingResults[0].addressComponents
                    let addressComponentsLocality = addressComponents.filter{$0.types.contains("locality")}
                    let addressComponentsNeborhood = addressComponents.filter{$0.types.contains("neighborhood")}
                    if addressComponentsNeborhood.count > 0 {
                        cityName = addressComponentsNeborhood[0].longName
                    } else if addressComponentsLocality.count > 0 {
                        cityName = addressComponentsLocality[0].longName
                    } else {
                        cityName = addressComponents[0].longName
                    }
                    return Result<String, Error>.Success(cityName)
                case .Failure(let error):
                    return Result<String, Error>.Failure(error)
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

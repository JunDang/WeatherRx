//
//  GeoCodingViewModel.swift
//  WeatherRx
//
//  Created by Jun Dang on 2018-07-29.
//  Copyright © 2018 Jun Dang. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import CoreLocation


class GeocodingViewModel {

    private let bag = DisposeBag()
    let apiType: InternetServiceProtocol.Type
    var geocodingModelObservable: Observable<Result<GeocodingModel, Error>>?
 
    // MARK: - Input for Geocoding
    var cityName: String
   
    // MARK: - Output
    var geoLocation: Observable<Result<CLLocationCoordinate2D, Error>>?
    var codedAdress: Observable<Result<String, Error>>?
   
// MARK: - Init
   init(cityName: String, apiType: InternetServiceProtocol.Type) {
       print("geo init called")
       self.cityName = cityName
       self.apiType = apiType
   
       geocodingModelObservable =  apiType.locationGeocoding(address: cityName)
       geoLocation = getLocation(geocodingModelObservable: geocodingModelObservable!)
       codedAdress = getAddress(geocodingModelObservable: geocodingModelObservable!)
   }
    
    func getLocation(geocodingModelObservable: Observable<Result<GeocodingModel, Error>>) -> Observable<Result<CLLocationCoordinate2D, Error>> {
       return geocodingModelObservable.map() {result in
           switch result {
           case .Success(let geocodingModel):
              let lat = geocodingModel.geocodingResults[0].geometry?.location?.lat
              let lon = geocodingModel.geocodingResults[0].geometry?.location?.lon
              let geoLocation = CLLocationCoordinate2D(latitude: lat!, longitude: lon!)
              return Result<CLLocationCoordinate2D, Error>.Success(geoLocation)
           case .Failure(let error):
              return Result<CLLocationCoordinate2D, Error>.Failure(error)
          }
      }
   }

    func getAddress(geocodingModelObservable: Observable<Result<GeocodingModel, Error>>) -> Observable<Result<String, Error>> {
        return  geocodingModelObservable.map() { result in
            switch result {
            case .Success(let geocodingModel):
                let adress = geocodingModel.geocodingResults[0].addressComponents[0].longName
                return Result<String, Error>.Success(adress)
            case .Failure(let error):
                return Result<String, Error>.Failure(error)
            }
        }
    }
}



//
//  ReverseGeocodingViewModel.swift
//  WeatherRx
//
//  Created by Jun Dang on 2018-07-29.
//  Copyright © 2018 Jun Dang. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

/*class ReverseGeocodingViewModel {
    
    private let bag = DisposeBag()
    let apiType: InternetServiceProtocol.Type
    var reverseGeocodingModelObservable: Observable<Result<ReverseGeocodingModel, Error>>?
  
    // MARK: - Input for reverseGeocoding
    let lat: Double?
    let lon: Double?
    
    // MARK: - Output
    var address: Observable<Result<String, Error>>?
    
    // MARK: - Init
    init(lat: Double, lon: Double, apiType: InternetServiceProtocol.Type) {
        print("reverseGeo init called")
        self.lat = lat
        self.lon = lon
        self.apiType = apiType
     
        reverseGeocodingModelObservable = apiType.reverseGeocoding(lat: lat, lon: lon)
        
        address = getAddress(reverseGeocodingModelObservable: reverseGeocodingModelObservable!)
        
        
}

   func getAddress(reverseGeocodingModelObservable: Observable<Result<ReverseGeocodingModel, Error>>) -> Observable<Result<String, Error>> {
       return  reverseGeocodingModelObservable.map() { result in
          switch result {
          case .Success(let reverseGeocodingModel):
             let adress = reverseGeocodingModel.reverseGeocodingResults[0].address
             return Result<String, Error>.Success(adress)
          case .Failure(let error):
             return Result<String, Error>.Failure(error)
          }
      }
   }
}*/

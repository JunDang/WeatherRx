//
//  GeoCodingService.swift
//  WeatherRx
//
//  Created by Jun Dang on 2018-07-28.
//  Copyright © 2018 Jun Dang. All rights reserved.
//

import Foundation


//MARK: -Geocoding
/*static func locationGeocoding(address: String) -> Observable<Result<GeocodingModel, Error>> {
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

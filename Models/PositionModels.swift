//
//  PositionModel.swift
//  WeatherRx
//
//  Created by Jun Dang on 2018-08-31.
//  Copyright © 2018 Jun Dang. All rights reserved.
//

import Foundation

struct GeocodingModel: Codable {
    private enum CodingKeys : String, CodingKey {
        case geocodingResults = "results"
    }
    var geocodingResults: [GeocodingResult] = []
}
struct GeocodingResult: Codable {
    private enum CodingKeys : String, CodingKey {
        case addressComponents = "address_components"
        case geometry = "geometry"
    }
    var addressComponents: [AddressComponent] = []
    var geometry: Geometry?
}
struct AddressComponent: Codable {
    private enum CodingKeys: String, CodingKey {
        case longName = "long_name"
        case shortName = "short_name"
        case types = "types"
    }
    var longName: String = ""
    var shortName: String = ""
    var types: [String] = []
    init(longName: String, shortName: String,types: [String]) {
        self.longName = longName
        self.shortName = shortName
        self.types = types
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        longName = try container.decode(String.self, forKey: .longName)
        shortName = try container.decode(String.self, forKey: .shortName)
        types = try container.decode(Array.self, forKey: .types)
    }
}
struct Geometry: Codable {
    private enum CodingKeys : String, CodingKey {
        case location = "location" }
    var location: Location?
}
struct Location: Codable {
    private enum CodingKeys: String, CodingKey {
        case lat = "lat"
        case lon = "lng"
    }
    var lat: Double = 0.0
    var lon: Double = 0.0
    
    init(lat: Double, lon: Double) {
        self.lat = lat
        self.lon = lon
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        lat = try container.decode(Double.self, forKey: .lat)
        lon = try container.decode(Double.self, forKey: .lon)
    }
}

//MARK: -ReverseGeocodingModel
struct ReverseGeocodingModel: Codable {
    private enum CodingKeys : String, CodingKey {
        case reverseGeocodingResults = "results"
    }
    var reverseGeocodingResults: [ReverseGeocodingResult] = []
}
struct ReverseGeocodingResult: Codable {
    private enum CodingKeys : String, CodingKey {
        case addressComponents = "address_components"
    }
    var addressComponents: [AddressComponent] = []
}

//
//  PositionModel.swift
//  WeatherRx
//
//  Created by Jun Dang on 2018-07-27.
//  Copyright © 2018 Jun Dang. All rights reserved.
//

import Foundation
import Foundation

/*struct PositionModel: Codable {
    /*private enum CodingKeys : String, CodingKey {
        case positionModel = "results" }*/
    var address: AddressComponents?
    var geometry: Geometry?
}
struct AddressComponents: Codable {
    private enum CodingKeys : String, CodingKey {
        case addressComponents = "address_components"}
 var addressComponents: [AddressCmoponent] = []
}
struct AddressCmoponent: Codable {
    private enum CodingKeys: String, CodingKey {
        case longName = "long_name"
    }
    var longName: String = ""
    init(longName: String) {
        self.longName = longName
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        longName = try container.decode(String.self, forKey: .longName)
    }
}
struct Geometry: Codable {
    private enum CodingKeys : String, CodingKey {
        case location = "geometry" }
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
}*/
struct PositionModel: Codable {
     private enum CodingKeys : String, CodingKey {
     case positionResults = "results"
    }
     var positionResults: [PositionResult] = []
}
struct PositionResult: Codable {
    private enum CodingKeys : String, CodingKey {
        case addressComponents = "address_components"
        case geometry = "geometry"
    }
    var addressComponents: [AddressCmoponent] = []
    var geometry: Geometry?
}
struct AddressCmoponent: Codable {
    private enum CodingKeys: String, CodingKey {
        case longName = "long_name"
    }
    var longName: String = ""
    init(longName: String) {
        self.longName = longName
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        longName = try container.decode(String.self, forKey: .longName)
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

//
//  DataModel.swift
//  WeatherRx
//
//  Created by Jun Dang on 2018-07-24.
//  Copyright © 2018 Jun Dang. All rights reserved.
//

/*import Foundation
import RxCocoa
import RealmSwift

@objcMembers class DataModel: Object {
    dynamic var latitude: Double = 0.0
    dynamic var longitude: Double = 0.0
    dynamic var weatherForecastModel: WeatherForecastModel?
    dynamic var flickrImageData: NSData?
    dynamic var compoundKey: String?
    //dynamic var updateTime: Int?
    
    convenience init(lat: Double, lon: Double, weatherForecastModel: WeatherForecastModel, flickrImageData: NSData/*, updateTime: Int*/) {
        self.init()
        self.latitude = lat
        self.longitude = lon
        self.weatherForecastModel = weatherForecastModel
        self.flickrImageData = flickrImageData
        //self.updateTime = updateTime
    }
    func configure(latitude: Double, longitude: Double){
        print("configureCompoundKey")
        self.latitude = latitude
        self.longitude = longitude
        self.compoundKey = "\(Int(self.latitude*10000))\(Int(self.longitude)*10000)"
    }
    override static func primaryKey() -> String? {
        return "compoundKey"
    }
}*/

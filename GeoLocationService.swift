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
}

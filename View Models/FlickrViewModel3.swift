//
//  FlickrViewModel3.swift
//  WeatherRx
//
//  Created by Jun Dang on 2018-07-26.
//  Copyright © 2018 Jun Dang. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa


/*class FlickrViewModel {
    
    private let bag = DisposeBag()
    
    let apiType: FlickrAPIProtocol.Type
    let imageDataCacheType: ImageDataCachingProtocol.Type
    // MARK: - Input
    let lat: Double
    let lon: Double
    let currentWeather: String
    
    // MARK: - Output
    var backgroundImage = BehaviorRelay<UIImage?>(value: nil)
    
    // MARK: - Init
    init(lat: Double, lon: Double, currentWeather:String, apiType: FlickrAPIProtocol.Type = InternetService.self, imageDataCacheType: ImageDataCachingProtocol.Type = ImageDataCaching.self) {
        self.lat = lat
        self.lon = lon
        self.currentWeather = currentWeather
        self.apiType = apiType
        self.imageDataCacheType = imageDataCacheType
        
        bindToBackgroundImage()
    }
    
    func bindToBackgroundImage() {
        try?apiType.searchImageURL(lat: lat, lon: lon, currentWeather:currentWeather)
            .flatMap ({imageURL  -> Observable<UIImage?> in
                return self.apiType.getImage(imageURL: imageURL, cache: self.imageDataCacheType)
                    .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            })
            .catchError { error in
                print("errorViewModel: " + "\(error)")
                return Observable.just(UIImage(named: "banff")!)
            }
            .share()
            .bind(to:backgroundImage)
            .disposed(by:bag)
    }
    
}*/


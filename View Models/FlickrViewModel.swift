//
//  FlickrViewModel.swift
//  WeatherRx
//
//  Created by Jun Dang on 2018-02-28.
//  Copyright © 2018 Jun Dang. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa


class FlickrViewModel {
    
    private let bag = DisposeBag()
    
    let apiType: FlickrAPIProtocol.Type
    let imageCacheType: ImageCachingProtocol.Type
    
    // MARK: - Input
    let lat: Double
    let lon: Double
    let currentWeather: String
    
    // MARK: - Output
    let backgroundImage = BehaviorRelay<UIImage?>(value: nil)
    
    // MARK: - Init
    init(lat: Double, lon: Double, currentWeather:String, apiType: FlickrAPIProtocol.Type = FlickrService.self, imageCacheType: ImageCachingProtocol.Type = ImageCaching.self) {
        
        self.lat = lat
        self.lon = lon
        self.currentWeather = currentWeather
        self.apiType = apiType
        self.imageCacheType = imageCacheType
       
        bindToBackgroundImage()
    }
    
    func bindToBackgroundImage() {
      
      try? apiType.searchImageURLAtLat(lat:lat, lon: lon, currentWeather: currentWeather)
        .flatMap ({imageURL -> Observable<UIImage> in
            if let imageFromCache = self.imageCacheType.imageFromURLFromChache(url: imageURL) {
              return Observable.just(imageFromCache)
            } else {
              return self.apiType.sendRequest(to: imageURL)
                .do(onNext: { (imageFromRequest) in
                   self.imageCacheType.saveImageToCache(image: imageFromRequest, url: imageURL)
                })
            }
       })
       .bind(to:backgroundImage)
       .disposed(by:bag)
    }
    
 }
    
   
    


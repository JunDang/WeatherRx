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
    let imageCache = NSCache<NSString, AnyObject>()
    // MARK: - Input
    let lat: Double
    let lon: Double
    let currentWeather: String
    
    // MARK: - Output
    let backgroundImage = Variable<UIImage?>(nil)
    
    // MARK: - Init
    init(lat: Double, lon: Double, currentWeather:String, apiType: FlickrAPIProtocol.Type = FlickrService.self) {
        
        self.lat = lat
        self.lon = lon
        self.currentWeather = currentWeather
        self.apiType = apiType
       
        bindToBackgroundImage()
    }
    
    func bindToBackgroundImage() {
      
             try? apiType.searchImageURLAtLat(lat:lat, lon: lon, currentWeather: currentWeather)
            .flatMap {imageURL in
                self.retrieveImage(imageURL: imageURL, imageCache: self.imageCache as! imageCachingProtocol)
          
            }
            .bind(to:backgroundImage)
            .disposed(by:bag)
        
    
       
    }
    
func retrieveImage(imageURL: NSURL, imageCache: imageCachingProtocol) -> Observable<UIImage> {
    if let imageFromCache = imageCache.imageFromURLFromChache(url: imageURL) {
        return Observable.just(imageFromCache)
    } else {
        return apiType.sendRequest(to: imageURL)
            .do(onNext: { (imageFromRequest) in
                imageCache.saveImageToCache(image: imageFromRequest, url: imageURL)
            }
                ,onError: <#T##((Error) throws -> Void)?##((Error) throws -> Void)?##(Error) throws -> Void#>
                ,onCompleted: {
                    
            })
        
        
    }
    
}
    
   /* .do(onNext: { image in
    self.imageCache.setObject(image, forKey: "\(self.lat)" + "\(self.lon)" + "\(self.currentWeather)" as NSString)
    },onError: { [weak self] e in
    guard let strongSelf = self else { return }
    DispatchQueue.main.async {
    strongSelf.showError(error: e)
    }
    })
    .bind(to:backgroundImage)
    .disposed(by:bag)
}*/
    
}

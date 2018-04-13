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
    //let imageCacheType: ImageCachingProtocol.Type
    let imageDataCacheType: ImageDataCachingProtocol.Type
    // MARK: - Input
    let lat: Double
    let lon: Double
    let currentWeather: String
    
    // MARK: - Output
    var backgroundImage = BehaviorRelay<UIImage?>(value: nil)
    
    // MARK: - Init
    init(lat: Double, lon: Double, currentWeather:String, apiType: FlickrAPIProtocol.Type = FlickrService.self, imageDataCacheType: ImageDataCachingProtocol.Type = ImageDataCaching.self/*imageCacheType: ImageCachingProtocol.Type = ImageCaching.self*/) {
        print("init")
        print("lat: " + "\(lat)")
        print("lon: " + "\(lon)")
        print("currentWeather: " + "\(currentWeather)")
        self.lat = lat
        self.lon = lon
        self.currentWeather = currentWeather
        self.apiType = apiType
        //self.imageCacheType = imageCacheType
        self.imageDataCacheType = imageDataCacheType
       
        bindToBackgroundImage()
    }
    
    /*func bindToBackgroundImage() {
       print("ImageCache1: " + "\(ImageCaching.imageCache)")
       print("bindToBackgroundImage")
        if let imageURL = try? apiType.searchImageURLAtLat(lat:lat, lon: lon, currentWeather: currentWeather).share() {
            imageURL.flatMap ({imageURL -> Observable<UIImage> in
                if let imageFromCache = self.imageCacheType.imageFromURLFromChache(url: imageURL) {
                    print("imageFromCache")
                    print("ImageCache1: " + "\(ImageCaching.imageCache)")
                    return Observable.just(imageFromCache)
                } else {
                    return self.apiType.sendRequest(to: imageURL)
                        .share()
                        .do(onNext: { (imageFromRequest) in
                            self.imageCacheType.saveImageToCache(image: imageFromRequest, url: imageURL)
                            print("saveImageToCache")
                            print("ImageCache2: " + "\(ImageCaching.imageCache)")
                            print()
                            }, onError: { e in
                            print("errorViewModel: " + "\(e)")
                        })
                 }
               })
                .catchError { error in
                    print("errorViewModel: " + "\(error)")
                    return Observable.just(UIImage(named: "banff")!)
               }
                .share()
              //.catchErrorJustReturn(UIImage(named: "banff")!)
                .bind(to:backgroundImage)
                .disposed(by:bag)
         } else {
            Observable.just(UIImage(named: "banff")!)
              .bind(to:backgroundImage)
              .disposed(by:bag)
        }
    }*/
    /*func bindToBackgroundImage() {
        if let imageURL = try? apiType.searchImageURLAtLat(lat:lat, lon: lon, currentWeather: currentWeather){
            imageURL.flatMap ({imageURL -> Observable<UIImage?> in
                 if let imageDataFromCache = self.imageDataCacheType.imageDataFromURLFromChache(url: imageURL) {
                   let imageFromCache = UIImage(data: imageDataFromCache as Data)
                    return Observable.just(imageFromCache)
                } else {
                    return self.apiType.sendRequest(to: imageURL)
                      .do(onNext: { (imageDataFromRequest) in
                            self.imageDataCacheType.saveImageDataToCache(data: imageDataFromRequest, url: imageURL)
                          }, onError: { e in
                            print("errorViewModel: " + "\(e)")
                        })
                        .map ({ imageDataFromRequest in
                            let imageFromRequest = UIImage(data: imageDataFromRequest as Data)
                            return imageFromRequest
                        })
                }
            })
                .catchError { error in
                   return Observable.just(UIImage(named: "banff")!)
                }
                .share()
                //.catchErrorJustReturn(UIImage(named: "banff")!)
                .bind(to:backgroundImage)
                .disposed(by:bag)
        } else {
            Observable.just(UIImage(named: "banff")!)
                .bind(to:backgroundImage)
                .disposed(by:bag)
        }
    }*/
    
    func bindToBackgroundImage() {
        try?apiType.searchImageURL(lat: lat, lon: lon, currentWeather:currentWeather)
            .flatMap ({imageURL  -> Observable<UIImage?> in
                 self.apiType.getImage(imageURL: imageURL, cache: self.imageDataCacheType)
                    .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
          })
                //.catchErrorJustReturn(UIImage(named: "banff")!)
             .catchError { error in
                print("errorViewModel: " + "\(error)")
                return Observable.just(UIImage(named: "banff")!)
              }
             .share()
             .bind(to:backgroundImage)
             .disposed(by:bag)
      }
    
}
/*{
    imageURL.subscribe(onNext: { (imageURL) in
        print("viewmodel imageURL: " + "\(String(describing: imageURL))")
    }, onError: {error in
        print("suscribeError: " + "\(error)")
        
    })
imageURL*/


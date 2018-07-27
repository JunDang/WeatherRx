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


/*class FlickrViewModel2 {
    
    private let bag = DisposeBag()
    
    let apiType: InternetServiceProtocol.Type
    // MARK: - Input
    let lat: Double
    let lon: Double
   
    
    // MARK: - Output
    //var flickrImage = BehaviorRelay<UIImage?>(value: nil)
    var flickrImageObservable: Observable<UIImage?>?
    
    // MARK: - Init
    init(lat: Double, lon: Double, apiType: InternetServiceProtocol.Type = InternetService.self) {
        self.lat = lat
        self.lon = lon
        self.apiType = apiType
        
        fetchflickrImageObservable()
    }
    
   
    func fetchflickrImageObservable() {
      let flickrImageObservable = apiType.searchImageURL(lat: lat, lon: lon)
            .flatMap ({result -> Observable<UIImage?> in
                switch result {
                case .Success(let imageURL):
                   return self.apiType.getImage(imageURL: imageURL)
                    .map(){result -> UIImage? in
                        switch result {
                        case .Success(let image):
                            return image
                        case .Failure(let error):
                            print(error)
                            return UIImage(named: "banff")!
                        }
                    }
                    .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
                case .Failure(let error):
                    print(error)
                    return Observable.just(UIImage(named: "banff")!)
                }
            })
         }

}*/


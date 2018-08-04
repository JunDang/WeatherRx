//
//  ViewModel2.swift
//  WeatherRx
//
//  Created by Jun Dang on 2018-07-25.
//  Copyright © 2018 Jun Dang. All rights reserved.
//
import Foundation
import RxCocoa
import RxSwift
import RxRealm
import RealmSwift
import RxSwiftUtilities

class ViewModel {
    private let bag = DisposeBag()
    let apiType: InternetServiceProtocol.Type
    let imageDataCacheType: ImageDataCachingProtocol.Type
    var weatherModelObservable: Observable<Result<WeatherForecastModel, Error>>?
    var imageResultObservable: Observable<Result<UIImage, Error>>?
    let activityIndicator = ActivityIndicator()
    
    // MARK: - Input
    let lat: Double
    let lon: Double
    
    // MARK: - Output
    var weatherForecastData: Observable<(AnyRealmCollection<WeatherForecastModel>, RealmChangeset?)>!
    var emptyWeatherForecastData: Observable<(AnyRealmCollection<WeatherForecastModel>, RealmChangeset?)>!
    var flickrImage = BehaviorRelay<UIImage?>(value: UIImage(named: "banff")!)
    
    // MARK: - Init
    init(lat: Double, lon: Double, apiType: InternetServiceProtocol.Type, imageDataCacheType: ImageDataCachingProtocol.Type = ImageDataCaching.self) {
        self.lat = lat
        self.lon = lon
        self.apiType = apiType
        self.imageDataCacheType = imageDataCacheType
        
        weatherModelObservable = apiType.getWeatherObservable(lat: lat, lon: lon)
                                     .trackActivity(activityIndicator)
                                     .observeOn(MainScheduler.instance)
           
        /*imageResultObservable =
            weatherModelObservable!
                .flatMap(){weatherModelResult -> Observable<Result<UIImage, Error>> in
                    switch weatherModelResult {
                    case .Success(let weatherForecastModel):
                        print("weatherForecastModel: " + "\(weatherForecastModel)")
                        return apiType.searchImageURL(lat: weatherForecastModel.latitude, lon: weatherForecastModel.longitude)
                            .flatMap ({resultNSURL -> Observable<Result<UIImage, Error>> in
                                print("resultNSURL: " + "\(resultNSURL)")
                                return self.apiType.getImage(resultNSURL: resultNSURL, cache: self.imageDataCacheType)
                            })
                    case .Failure(let error):
                        return Observable.just(Result<UIImage, Error>.Failure(error))
                    }
        }*/
        imageResultObservable =
                                apiType
                                    .searchImageURL(lat: lat, lon: lon)
                                    .flatMap ({resultNSURL -> Observable<Result<UIImage, Error>> in
                                        //print("resultNSURL: " + "\(resultNSURL)")
                                        return self.apiType.getImage(resultNSURL: resultNSURL, cache: self.imageDataCacheType)
                                    })
        
        bindOutPut()
        writeWeatherModelInRealm(weatherModelObservable:weatherModelObservable!)
    }
    
    func writeWeatherModelInRealm(weatherModelObservable: Observable<Result<WeatherForecastModel, Error>>) {
        weatherModelObservable
            //.observeOn(MainScheduler.instance)
            .subscribe(onNext: { result in
                switch result {
                case .Success(let weatherForecastModel):
                    weatherForecastModel.configure(latitude: weatherForecastModel.latitude, longitude: weatherForecastModel.longitude)
                    let realm = try! Realm()
                    try! realm.write {
                        realm.add(weatherForecastModel, update: true)
                    }
                case .Failure(let error):
                    print(error)
                }
            })
            .disposed(by: bag)
    }
    
   func bindOutPut() {
        print("bindOutput")
        guard let realm = try? Realm() else {
            return
        }
        weatherForecastData = Observable.changeset(from: realm.objects(WeatherForecastModel.self))
        weatherForecastData.subscribe(onNext: {weatherdata in
           // print("weatherForecastData: " + "\(weatherdata)")
        })
        
       let imageObservable =
                         imageResultObservable!.map() { result -> UIImage in
                            switch result {
                            case .Success(let image):
                            return image
                            case .Failure:
                            return UIImage(named: "banff")!
                            }
                         }
    imageObservable
        .bind(to: flickrImage)
        .disposed(by:bag)
    
    }
}


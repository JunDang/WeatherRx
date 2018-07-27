//
//  ViewModel.swift
//  WeatherRx
//
//  Created by Jun Dang on 2018-07-24.
//  Copyright © 2018 Jun Dang. All rights reserved.
//


import Foundation
import RxCocoa
import RxSwift
import RxRealm
import RealmSwift

/*class ViewModel {
    private let bag = DisposeBag()
    var dataModelObservable: Observable<Result<DataModel, Error>>?
    let apiType: InternetServiceProtocol.Type
    var weatherObservable: Observable<Result<WeatherForecastModel, Error>>?
    var imageObservable: Observable<Result<UIImage, Error>>?
    
    // MARK: - Input
    let lat: Double
    let lon: Double
    
    
    // MARK: - Output
    var dataModelObservableFromRealm: Observable<(AnyRealmCollection<DataModel>, RealmChangeset?)>!
   
    
    // MARK: - Init
    
    init(lat: Double, lon: Double, apiType: InternetServiceProtocol.Type) {
        print("wwv init called")
        self.lat = lat
        self.lon = lon
        self.apiType = apiType
        
       weatherObservable = apiType.getWeatherObservable(lat: lat, lon: lon)
       
       imageObservable = apiType.searchImageURL(lat: lat, lon: lon)
                            .flatMap ({result -> Observable<Result<UIImage, Error>> in
                                switch result {
                                case .Success(let imageURL):
                                    return self.apiType.getImage(imageURL: imageURL)
                                        .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
                                case .Failure(let error):
                                    print(error)
                                    return Observable.just(Result<UIImage, Error>.Success(UIImage(named: "banff")!))
                                }
                             })
        
        Observable.zip(weatherObservable, imageObservable) {($0, $1)}
            .subscribe(onNext: {(weatherForecastModelResult, flickrImageResult) in
                switch (weatherForecastModelResult, flickrImageResult) {
                   case .Success(let weatherForecastModel, let flickrImage):
                    let dataModel = DataModel(lat: self.lat, lon: self.lon, weatherForecastModel: weatherForecastModel, flickrImage: flickrImage!)
                   case .Failure(let error):
                     print(error)
                }
              })
              .disposed(by: bag)
        
                
                
        
    }
    
    func writeWeatherInRealm(weatherObservable: Observable<Result<WeatherForecastModel, Error>>) {
        weatherObservable
            .subscribe(onNext: { result in
                switch result {
                case .Success(let weatherModel):
                    // print("weatherModel: " + "\(weatherModel)")
                    // print("latitude: " + "\(weatherModel.latitude)")
                    // print("longitude: " + "\(weatherModel.longitude)")
                    weatherModel.configure(latitude: weatherModel.latitude, longitude: weatherModel.longitude)
                    print("compoundkey: " + "\(weatherModel.compoundKey)")
                    let realm = try! Realm()
                    try! realm.write {
                        realm.add(weatherModel, update: true)
                    }
                    /*   let weatherForecastModels = realm.objects(WeatherForecastModel.self)
                     let firstItem = weatherForecastModels.first
                     // let firstItem =  (weatherForecastModels[0].hourly)?.hourlyWeatherModel.count
                     print("firstItem: " + "\(firstItem)")
                     //print("weatherForecastModels: " + "\(weatherForecastModels)")*/
                case .Failure(let error):
                    print(error)
                }
            })
            .disposed(by: bag)
    }
    
    func bindWeather() {
        print("bindWeather")
        guard let realm = try? Realm() else {
            return
        }
        /*let weatherForecastModels = realm.objects(WeatherForecastModel.self)
         
         print("weatherForecastModels: " + "\(weatherForecastModels)")*/
        
        weatherForecastData = Observable.changeset(from: realm.objects(WeatherForecastModel.self))
        /*weatherForecastData
         .subscribe(onNext: { (element) in
         print("WeatherData: " + "\(element)")
         })
         .disposed(by: bag)
         }*/
        
    }
}

class FlickrViewModel3 {
    
    private let bag = DisposeBag()
    
    let apiType: FlickrAPIProtocol.Type
    // MARK: - Input
    let lat: Double
    let lon: Double
    let currentWeather: String
    
    
    // MARK: - Output
    var backgroundImage = BehaviorRelay<UIImage?>(value: nil)
    
    // MARK: - Init
    init(lat: Double, lon: Double, currentWeather: String, apiType: FlickrAPIProtocol.Type = InternetService.self) {
        self.lat = lat
        self.lon = lon
        self.currentWeather = currentWeather
        self.apiType = apiType
        
        bindToBackgroundImage()
    }
    
    func bindToBackgroundImage() {
        try?apiType.searchImageURL(lat: lat, lon: lon, currentWeather: currentWeather)
            .flatMap ({imageURL  -> Observable<UIImage?> in
                return self.apiType.getImage(imageURL: imageURL)
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

// -MARK: if use DataModel
/*let dataModelObservable: Observable<Result<DataModel, Error>> = apiType.getWeatherObservable(lat: lat, lon: lon)
    .flatMap({weatherModelResult -> Observable<Result<DataModel, Error>> in
        switch weatherModelResult {
        case .Success(let weatherForecastModel):
            print("weatherForecastModel: " + "\(weatherForecastModel)")
            return apiType.searchImageURL(lat: weatherForecastModel.latitude, lon: weatherForecastModel.longitude)
                .flatMap ({resultNSURL -> Observable<Result<UIImage, Error>> in
                    print("resultNSURL: " + "\(resultNSURL)")
                    return self.apiType.sendRequest(resultNSURL:resultNSURL)
                }).map({uiImageResult -> Result<DataModel, Error> in
                    switch uiImageResult {
                    case .Success(let flickrImage):
                        print("flickrImage: " + "\(flickrImage)")
                        return Result.Success(DataModel(lat: weatherForecastModel.latitude, lon: weatherForecastModel.longitude, weatherForecastModel: weatherForecastModel, flickrImage: flickrImage))
                    case .Failure(let error):
                        return Result<DataModel, Error>.Failure(error)
                    }
                    }
            )
        case .Failure(let error):
            return Observable.just(Result<DataModel, Error>.Failure(error))
        }
    })

dataModelObservable.subscribe(onNext: { result in
    print("dataModelObservable: " + "\(result)")
})
    .disposed(by: bag)*/

//
//  WeatherViewModel.swift
//  WeatherRx
//
//  Created by Jun Dang on 2018-07-07.
//  Copyright © 2018 Jun Dang. All rights reserved.
//

import Foundation

import RealmSwift
import RxSwift
import RxRealm
import RxCocoa

class WeatherViewModel {
    private let bag = DisposeBag()
    var weatherObservable: Observable<Result<WeatherForecastModel, Error>>?
    let apiType: WeatherAPIProtocol.Type
    
    // MARK: - Input
    let lat: Double
    let lon: Double
    
    
    // MARK: - Output
    var weatherForecastData:Observable<(AnyRealmCollection<WeatherForecastModel>, RealmChangeset?)>!
    //var weatherForecastModel = BehaviorRelay<WeatherForecastModel?>(value: nil)
   
    // MARK: - Init
    
    init(lat: Double, lon: Double, apiType: WeatherAPIProtocol.Type = InternetService.self) {
        print("wwv init called")
        self.lat = lat
        self.lon = lon
        self.apiType = apiType
       
        weatherObservable = InternetService.getWeatherObservable(lat: lat, lon: lon)
        
        bindWeather()
        writeWeatherInRealm(weatherObservable: weatherObservable!)
        
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

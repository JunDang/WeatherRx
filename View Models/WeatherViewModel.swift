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
    //var weatherForecastObservable: Observable<WeatherForecastModel>?
    let apiType: WeatherAPIProtocol.Type
    
    // MARK: - Input
    let lat: Double
    let lon: Double
    
    // MARK: - Output
    //var weatherForecastData:Observable<(AnyRealmCollection<WeatherForecastModel>, RealmChangeset?)>!
    var currentlyWeatherData: Observable<(AnyRealmCollection<CurrentlyWeatherModel>, RealmChangeset?)>!
    var hourlyWeatherData: Observable<(AnyRealmCollection<HourlyWeatherModel>, RealmChangeset?)>!
    var dailyWeatherData: Observable<(AnyRealmCollection<DailyWeatherModel>, RealmChangeset?)>!
    
    // MARK: - Init
   /* init(lat: Double, lon: Double, apiType: WeatherAPIProtocol.Type = InternetService.self) {
        self.lat = lat
        self.lon = lon
        self.apiType = apiType
        
        let weatherForecast = InternetService.getWeatherObservable(lat: lat, lon: lon)
        guard let realm = try? Realm() else {
            return
        }
        weatherForecast
        .subscribe(onNext: {weatherData in
            try! realm.write {
              realm.add(weatherData, update: true)
            }
        })
            .disposed(by: bag)
        
        weatherForecastData = Observable.changeset(from: realm.objects(WeatherForecastModel.self))
    }*/
    
    init(lat: Double, lon: Double, apiType: WeatherAPIProtocol.Type = InternetService.self) {
        print("wwv init called")
        self.lat = lat
        self.lon = lon
        self.apiType = apiType
        //let weatherForecastObservable = InternetService.getWeatherObservable(lat: lat, lon: lon)
        
       // let currentlyWeatherObservable = weatherForecastObservable.map({$0.currently})
       /* currentlyWeatherObservable
            .subscribe(Realm.rx.add(update: true))
            .disposed(by: bag)
        let hourlyWeatherObservable = weatherForecastObservable.map({$0.hourly})
        let dailyWeatherObservable = weatherForecastObservable.map({$0.daily})*/
        
        writeCurrentlyWeatherInRealm()
        //writeHourlyWeatherInRealm()
       // writeDailyWeatherInRealm()
        //bindCurrentlyWeather()
    
        
    }
    func writeCurrentlyWeatherInRealm() {
        print("writeCurrentlyWeatherInRealm")
        let currentlyWeatherModelObservable = InternetService.getCurrentlyWeatherObservable(lat: lat, lon: lon)
        currentlyWeatherModelObservable
            .subscribe(onNext: { result in
                switch result {
                case .Success(let currentlyWeatherModel):
                   print("currentlyWeatherModel: " + "\(currentlyWeatherModel)")
                   let realm = try! Realm()
                   try! realm.write {
                     realm.add(currentlyWeatherModel, update: true)
                  }
                 case .Failure(let error):
                   print(error)
                }
            })
            .disposed(by: bag)
        
       /* guard let realm = try? Realm() else {
            return
        }
        currentlyWeatherData = Observable.changeset(from: realm.objects(CurrentlyWeatherModel.self))*/
    }
        
    func bindCurrentlyWeather() {
        print("bindCurrentlyWeather")
        guard let realm = try? Realm() else {
            return
        }
        currentlyWeatherData = Observable.changeset(from: realm.objects(CurrentlyWeatherModel.self))
        print("currentlyWeatherData: " + "\(currentlyWeatherData)")
        }
    }
   /* func writeHourlyWeatherInRealm() {
        let hourlyWeatherObservable = weatherForecastObservable.map({$0.hourly})
        hourlyWeatherObservable
            .subscribe(Realm.rx.add(update: true))
            .disposed(by: bag)
        
        guard let realm = try? Realm() else {
            return
        }
        hourlyWeatherData = Observable.changeset(from: realm.objects(HourlyWeatherModel.self))
    }
    func writeDailyWeatherInRealm() {
        let dailyWeather = InternetService.getDailyWeatherObservable(lat: lat, lon: lon)
        dailyWeather
            .subscribe(Realm.rx.add(update: true))
            .disposed(by: bag)
        
        guard let realm = try? Realm() else {
            return
        }
        dailyWeatherData = Observable.changeset(from: realm.objects(DailyWeatherModel.self))
    }*/



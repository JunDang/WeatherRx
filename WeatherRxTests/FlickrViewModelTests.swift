//
//  FlickrViewModelTests.swift
//  WeatherRxTests
//
//  Created by Jun Dang on 2018-04-27.
//  Copyright © 2018 Jun Dang. All rights reserved.
//

import XCTest
import RxSwift
import RxCocoa
import Unbox
import RxBlocking

@testable import WeatherRx

class FlickrViewModelTests: XCTestCase {
  
    private func createViewModel(_ lat:Double, _ lon: Double, _ currentWeather: String) -> FlickrViewModel {
        return FlickrViewModel(lat: lat, lon: lon, currentWeather:currentWeather, apiType: MockFlickrService.self, imageDataCacheType: ImageDataCaching.self)
    }
    
    func test_whenInitialized_storesInitParams() {
        let lat = 43.6532
        let lon = -79.3832
        let currentWeather = "sunny"
        let viewModel = createViewModel(lat, lon, currentWeather)
        
        XCTAssertNotNil(viewModel.lat)
        XCTAssertNotNil(viewModel.lon)
        XCTAssertNotNil(viewModel.currentWeather)
        XCTAssertNotNil(viewModel.apiType)
        XCTAssertNotNil(viewModel.imageDataCacheType)
    }
    
     func test_whenInit_callsBindToBackgroundImage_FetchImage() {
       
        
        let lat = 43.6532
        let lon = -79.3832
        let currentWeather = "sunny"
        let viewModel = createViewModel(lat, lon, currentWeather)
        XCTAssertNil(viewModel.backgroundImage.value, "backgroundImage is not nil by default")
        
        let backgroundImage = viewModel.backgroundImage.asObservable()
        
        DispatchQueue.main.async {
            MockFlickrService.flickrImageURL.onNext(TestData.stubImageURL!)
            MockFlickrService.flickrImageData.onNext(TestData.stubFlickrImageData! as NSData)
        }
               
        let emitted = try! backgroundImage.take(2).toBlocking(timeout: 1).toArray()
        XCTAssertNil(emitted[0])
        XCTAssertEqual(UIImagePNGRepresentation(emitted[1]!), TestData.stubFlickrImageData)
      
    }
    
    
    
}

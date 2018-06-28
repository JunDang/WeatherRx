//
//  WeatherTest.swift
//  WeatherRx
//
//  Created by Jun Dang on 2017-09-27.
//  Copyright © 2017 Jun Dang. All rights reserved.
//

import XCTest

/*class WeatherTest: XCTestCase {
    
    private let dummyTempFarenheit1 = 14.0
    private let dummyWindSpeedMPH = 10.0
    private let dummyWindBearing = 315.0
     
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testConvertingFarenheitToCelcius1() {
        let weather1 = Weather(cityName: "xichang",
                               weatherSummary: "sunny",
                               icon: "sun",
                               time: 0.0,
                               tempFarenheit: dummyTempFarenheit1,
                               maxTempFarenheit: 0.0,
                               minTempFarenheit: 0.0,
                               precipitationProbability: 0.0,
                               precipitationIntensity: 0.0,
                               dewPoint: 0.0,
                               humidity: 0.0,
                               windSpeedMPH: 0.0,
                               windBearing: 0.0,
                               sunriseTime: 0.0,
                               sunsetTime: 0.0,
                               cloudCover: 0.0)
        let expectedTempCelsius1 = -10.0
        let stringExpectedTempCelsius1 = String(format: "%.1f", expectedTempCelsius1)
        let convertedTempCelsius1 = weather1.tempCelsius
        let stringConvertedTempCelsius1 = String(format: "%.1f", convertedTempCelsius1)
        XCTAssertEqual(stringExpectedTempCelsius1, stringConvertedTempCelsius1)
        
    }
    
    func testConvertingMPHtoKPH() {
        let weather2 = Weather(cityName: "xichang",
                               weatherSummary: "sunny",
                               icon: "sun",
                               time: 0.0,
                               tempFarenheit: 0.0,
                               maxTempFarenheit: 0.0,
                               minTempFarenheit: 0.0,
                               precipitationProbability: 0.0,
                               precipitationIntensity: 0.0,
                               dewPoint: 0.0,
                               humidity: 0.0,
                               windSpeedMPH: dummyWindSpeedMPH,
                               windBearing: 0.0,
                               sunriseTime: 0.0,
                               sunsetTime: 0.0,
                               cloudCover: 0.0)
        let expectedWindSpeedKPH = 16.0934
        let stringExpectedWindSpeedKPH = String(format: "%.2f", expectedWindSpeedKPH)
        let convertedWindSpeedKPH = weather2.windSpeedKPH
        let stringConvertedWindSpeedKPH = String(format: "%.2f", convertedWindSpeedKPH)
        XCTAssertEqual(stringExpectedWindSpeedKPH, stringConvertedWindSpeedKPH)
        
    }
    
    func testConvertingWindBearingToWindDirection() {
        let weather3 = Weather(cityName: "xichang",
                               weatherSummary: "sunny",
                               icon: "sun",
                               time: 0.0,
                               tempFarenheit: 0.0,
                               maxTempFarenheit: 0.0,
                               minTempFarenheit: 0.0,
                               precipitationProbability: 0.0,
                               precipitationIntensity: 0.0,
                               dewPoint: 0.0,
                               humidity: 0.0,
                               windSpeedMPH: 0.0,
                               windBearing: dummyWindBearing,
                               sunriseTime: 0.0,
                               sunsetTime: 0.0,
                               cloudCover: 0.0)
        let expectedWindDirection = "NW"
        let convertedWindDirection = weather3.windDirection
        XCTAssertEqual(expectedWindDirection, convertedWindDirection)
        
    }
    
    
}*/

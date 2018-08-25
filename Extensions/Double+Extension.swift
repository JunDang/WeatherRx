//
//  Double+Extension.swift
//  WeatherRx
//
//  Created by Jun Dang on 2018-06-24.
//  Copyright © 2018 Jun Dang. All rights reserved.
//

import Foundation

extension Double {
    
    func toCelcius() -> Double {
        return ((self - 32.0) / 1.8)
    }
    func toCentimeter() -> Double {
        return (self * 2.54)
    }
    func toKPH() -> Double {
        return (self * 1.609344)
    }
    
    func roundToInt() -> Int {
        return Int(self.rounded())
    }
    
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

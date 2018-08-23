//
//  ChartVlueFormatter.swift
//  WeatherRx
//
//  Created by Jun Dang on 2018-08-22.
//  Copyright © 2018 Jun Dang. All rights reserved.
//

import Foundation
import Charts

class ChartValueFormatter: NSObject, IValueFormatter {
    private var numberFormatter: NumberFormatter?
    
    convenience init(numberFormatter: NumberFormatter) {
        self.init()
        self.numberFormatter = numberFormatter
    }
    
    func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
        guard let numberFormatter = numberFormatter
            else {
                return ""
        }
        return numberFormatter.string(for: value)!
    }
}

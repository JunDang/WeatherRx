//
//  InternetAPIProtocol.swift
//  WeatherRx
//
//  Created by Jun Dang on 2018-03-08.
//  Copyright © 2018 Jun Dang. All rights reserved.
//

import Foundation

protocol InternetAPIProtocol {
    static func composeURL(from baseURL: String, parameters: [String:String]) -> URL
}

//
//  InternetAPI.swift
//  WeatherRx
//
//  Created by Jun Dang on 2018-02-22.
//  Copyright © 2018 Jun Dang. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

typealias JSONObject = [String: Any]

protocol InternetAPIProtocol {
    static func composeURL(from baseURL: String, parameters: [String:String]) -> URL
    
}

struct InternetAPI: InternetAPIProtocol {
    static func composeURL(from baseURL: String = "", parameters: [String:String] = [:]) -> URL {
        var components = URLComponents(string: baseURL)!
        components.queryItems = parameters.map(URLQueryItem.init)
        let url = try! components.asURL()
        return url
    }
}

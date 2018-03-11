//
//  ImageCachingProtocol.swift
//  WeatherRx
//
//  Created by Jun Dang on 2018-03-08.
//  Copyright © 2018 Jun Dang. All rights reserved.
//


import Foundation
import UIKit

protocol ImageCachingProtocol {
    
    static func saveImageToCache(image: UIImage?, url: NSURL)
    static func imageFromURLFromChache(url: NSURL) -> UIImage?
    
}

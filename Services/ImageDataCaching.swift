//
//  ImageDataCaching.swift
//  WeatherRx
//
//  Created by Jun Dang on 2018-09-05.
//  Copyright © 2018 Jun Dang. All rights reserved.
//

import Foundation

import Foundation
import UIKit

class ImageDataCaching: ImageDataCachingProtocol {
    
    static var imageDataCashe = NSCache<AnyObject, AnyObject>()
    
    static func saveImageDataToCache(data: NSData?, url: NSURL) {
        if let data = data {
            imageDataCashe.setObject(data, forKey: url)
        }
    }
    
    static func imageDataFromURLFromChache(url: NSURL) -> NSData? {
        return imageDataCashe.object(forKey: url) as? NSData
    }
}

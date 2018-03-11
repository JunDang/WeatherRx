//
//  ImageCaching.swift
//  WeatherRx
//
//  Created by Jun Dang on 2018-03-08.
//  Copyright © 2018 Jun Dang. All rights reserved.
//

import Foundation
import UIKit

class ImageCaching: ImageCachingProtocol {
    
   static var imageCache = NSCache<AnyObject, AnyObject>()
    
   static func saveImageToCache(image: UIImage?, url: NSURL) {
        if let image = image {
            imageCache.setObject(image, forKey: url)
        }
    }
    
   static func imageFromURLFromChache(url: NSURL) -> UIImage? {
        return imageCache.object(forKey: url) as? UIImage
    }
    
    
}


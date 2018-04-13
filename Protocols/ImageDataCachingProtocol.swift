//
//  ImageDataCachingProtocol.swift
//  WeatherRx
//
//  Created by Jun Dang on 2018-04-02.
//  Copyright © 2018 Jun Dang. All rights reserved.
//

import Foundation
import UIKit

protocol ImageDataCachingProtocol {

   static var imageDataCashe:  NSCache<AnyObject, AnyObject> { get }
   static func saveImageDataToCache(data: NSData?, url: NSURL)
   static func imageDataFromURLFromChache(url: NSURL) -> NSData?
    
}

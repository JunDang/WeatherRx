//
//  FlickrPhotos.swift
//  WeatherRx
//
//  Created by Jun Dang on 2018-06-18.
//  Copyright © 2018 Jun Dang. All rights reserved.
//

import Foundation

struct FlickrPhoto: Codable {
    var farm: Int64 = 0
    var server: String = ""
    var photoID: String = ""
    var secret: String = ""
    
    func createImageURL() -> NSURL {
        return NSURL(string: "http://farm\(farm).staticflickr.com/\(server)/\(photoID)_\(secret)_b.jpg")!
    }
}

struct FlickrPhotos: Codable {
    var flickrPhotos: [FlickrPhoto] = []
}

struct FlickrModel: Codable {
    var flickrResult: FlickrPhotos?
}

//
//  FlickrPhoto.swift
//  WeatherRx
//
//  Created by Jun Dang on 2018-01-29.
//  Copyright © 2018 Jun Dang. All rights reserved.
//

import Foundation
import Unbox
import RealmSwift



/*class FlickrPhoto: Unboxable {
    var farm: Int64 = 0
    var server: String = ""
    var photoID: String = ""
    var secret: String = ""
  
    convenience required init(unboxer: Unboxer) throws {
        self.init()
        
        photoID = try unboxer.unbox(key: "id")
        farm = try unboxer.unbox(key: "farm")
        secret = try unboxer.unbox(keyPath: "secret")
        server = try unboxer.unbox(key: "server")
    }
    func createImageURL() -> NSURL {
        return NSURL(string: "http://farm\(farm).staticflickr.com/\(server)/\(photoID)_\(secret)_b.jpg")!
    }
}

class FlickrPhotos: Unboxable {
    var flickrPhotos: [FlickrPhoto] = []
    convenience required init(unboxer: Unboxer) throws {
        self.init()
        flickrPhotos = try unboxer.unbox(key: "photo")
     }
}

class FlickrPhotoResult: Unboxable {
    var flickrPhotoResult: FlickrPhotos?
    convenience required init(unboxer: Unboxer) throws {
        self.init()
        flickrPhotoResult = unboxer.unbox(key: "photos")
    }
}*/





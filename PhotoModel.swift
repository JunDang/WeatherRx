//
//  PhotoModel.swift
//  WeatherRx
//
//  Created by Jun Dang on 2018-07-25.
//  Copyright © 2018 Jun Dang. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers class PhotoModel: Object, Decodable {
    private enum CodingKeys : String, CodingKey {
        case photoModel = "photos" }
    var photoModel: Photos?
    dynamic var primaryKey: String?

    func configure(url: NSURL){
        self.primaryKey = "url"
    }
}

@objcMembers class Photos:  Object, Decodable {
    private enum CodingKeys : String, CodingKey {
        case photos = "photo" }
    var photos = List<Photo>()
    convenience init(photos:List<Photo>) throws {
        self.init()
        self.photos = photos
    }
    convenience required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let photoArray = try container.decode([Photo].self, forKey: .photos)
        let photoList = List<Photo>()
        photoList.append(objectsIn: photoArray)
        try self.init(photos: photoList)
    }
}

@objcMembers class Photo: Object, Decodable {
    dynamic var farm: Int = 0
    dynamic var server: String = ""
    dynamic var id: String = ""
    dynamic var secret: String = ""
    
    private enum CodingKeys: String, CodingKey {
        case farm = "farm", server = "server", id = "id", secret = "secret"
    }
    convenience init(farm: Int, id: String, server: String, secret: String) {
        self.init()
        self.farm = farm
        self.id = id
        self.server = server
        self.secret = secret
    }
    convenience required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let farm = try container.decode(Int.self, forKey: .farm)
        let server = try container.decode(String.self, forKey: .server)
        let id = try container.decode(String.self, forKey: .id)
        let secret = try container.decode(String.self, forKey: .secret)
        try self.init(farm: farm, id: id, server: server, secret: secret)
    }
    func createImageURL() -> NSURL {
        return NSURL(string: "http://farm\(String(describing: farm)).staticflickr.com/\(String(describing: server))/\(String(describing: id))_\(String(describing: secret))_b.jpg")!
    }
}


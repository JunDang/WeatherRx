//
//  PhotoModels.swift
//  WeatherRx
//
//  Created by Jun Dang on 2018-06-21.
//  Copyright © 2018 Jun Dang. All rights reserved.
//

import Foundation

struct PhotoModel: Codable {
    let id: String
    let owner: String
    let secret: String
    let server: String
    let farm: Int
    let title: String
    let ispublic: Int
    let isfriend: Int
    let isfamily: Int
}

struct PhotosModel: Codable {
    let pages: String
    let total: String
    let perpage: Int
    let page: Int
    let photo: [PhotoModel]
}

struct FlickrModel1: Codable {
    let photos: PhotosModel
    let stat: String
}

//
//  GiftListModel.swift
//  EydsCanadaRecruitment
//
//  Created by Mac-09 on 17/08/23.
//

import Foundation

struct GifListModel: Codable {
    var gifList: [GifData]?
    
    enum CodingKeys: String, CodingKey {
         case gifList = "data"
    }
}

struct GifData: Codable {
    var images: ImageData?
    var isFavourite : Bool? // added to handle the btnFavImg
    var id: String?
    enum CodingKeys: String, CodingKey {
         case images = "images"
        case isFavourite = "isFavourite"
        case id = "id"
    }
}

struct ImageData: Codable {
    var originalData: Original?
    
    enum CodingKeys: String, CodingKey {
         case originalData = "original"
    }
}

struct Original: Codable {
    var gifUrl: String?
    
    enum CodingKeys: String, CodingKey {
    case gifUrl = "url"
    }
}

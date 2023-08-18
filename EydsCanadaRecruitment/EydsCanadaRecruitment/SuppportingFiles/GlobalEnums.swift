//
//  GlobalEnums.swift
//  EydsCanadaRecruitment
//
//  Created by Mac-09 on 16/08/23.
//

import UIKit
import Foundation


enum TableViewCells: String {
    case gifDisplayCell
    
    var identifier: String {
        switch self {
        case .gifDisplayCell:
            return "GifDisplayCellIdef"
        }
    }
}

enum CollectionViewCells: String {
    case gifListCollectionCell
    
    var identifier: String {
        switch self {
        case .gifListCollectionCell:
            return "GifListCollectionCellIdef"
        }
    }
}

enum UserDefaultsKeys: String {
    case FavouriteGifsArray
}

enum ImagesName: String {
     case fav = "fav.png"
     case  nonFav = "nonFav.png"
}

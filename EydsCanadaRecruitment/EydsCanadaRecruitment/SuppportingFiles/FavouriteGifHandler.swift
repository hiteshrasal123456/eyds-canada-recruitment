//
//  FavouriteGifHandler.swift
//  EydsCanadaRecruitment
//
//  Created by Mac-09 on 18/08/23.
//

import UIKit

class FavouriteGifHandler {
    let userDefaultsObj = UserDefaultsManager();
    func saveGifImgDataToUserDefaults(fileName: String) {
        if let gifArray = userDefaultsObj.getDataFromDefaults(key: UserDefaultsKeys.FavouriteGifsArray.rawValue) as? [String]{
            var updatedArray = gifArray;
            updatedArray.append(fileName);
            userDefaultsObj.saveDataToDefaults(data: updatedArray, key: UserDefaultsKeys.FavouriteGifsArray.rawValue)
        } else {
            var gifImgArray = [String]()
            gifImgArray.append(fileName);
            userDefaultsObj.saveDataToDefaults(data: gifImgArray, key: UserDefaultsKeys.FavouriteGifsArray.rawValue)
        }
    }
    
    func getAllFavouriteImageNameFromDefaults() -> [String]? {
        
        if let gifArray = userDefaultsObj.getDataFromDefaults(key: UserDefaultsKeys.FavouriteGifsArray.rawValue) as? [String] {
            return gifArray
        }
        return nil;
    }
    
    func removeObjFromUserDefaults(key: String) {
        userDefaultsObj.removeDataFromDefaults(key: key);
    }
    
    func saveObjToUserDefaults(key: String, data: [String]) {
        userDefaultsObj.saveDataToDefaults(data: data, key: key)
    }
}

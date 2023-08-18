//
//  FavouriteVcVM.swift
//  EydsCanadaRecruitment
//
//  Created by Mac-09 on 18/08/23.
//

import UIKit
import Foundation
class FavouriteVcVM {
    let gifImgProvider: GifHandlerManagerProtocol;
    var gifImgArray: [String]?
    
    init(gifImgProvider: GifHandlerManagerProtocol = GifImagesHandlerManager()) {
        self.gifImgProvider = gifImgProvider
    }
    
    func getGifImgArrayFromDefaults(completion: @escaping () -> ()) {
        let obj = FavouriteGifHandler();
        if let arr = obj.getAllFavouriteImageNameFromDefaults() {
            self.gifImgArray = arr;
          }
    }
    
    func numOfRows() -> Int {
        return self.gifImgArray?.count ?? 0
    }
    
    func getGifImg(rowNo: Int) -> UIImage {
        if let gifImgArray = self.gifImgArray {
            let gifUrl = gifImgArray[rowNo]
            if let gifImg =
                self.gifImgProvider.readFromDocDir(fileName: gifUrl) {
                return gifImg;
            }
        }
        return UIImage();
        
    }
    
    func btnIsFavourtiteAction(rowNo: Int) {
        self.removeFromDocDir(rowNo: rowNo);
        self.gifImgArray?.remove(at: rowNo);
        self.removeFromUserDefaults();
    }
    // removed unfavourite image name from userdefaults
    func removeFromUserDefaults() {
        let obj = FavouriteGifHandler();
        obj.removeObjFromUserDefaults(key: UserDefaultsKeys.FavouriteGifsArray.rawValue);
        if self.gifImgArray?.count ?? 0 > 0 {
            if let gifImgArray = self.gifImgArray {
                obj.saveObjToUserDefaults(key:UserDefaultsKeys.FavouriteGifsArray.rawValue , data: gifImgArray)
            }
            
        }
    }
    // removed unfavourite image  from document directory
    func removeFromDocDir(rowNo: Int) {
        if let gifImgArray = self.gifImgArray {
            let gifUrl = gifImgArray[rowNo]
            self.gifImgProvider.deleteFileFromDocDir(gifUrl)
        }
    }
}

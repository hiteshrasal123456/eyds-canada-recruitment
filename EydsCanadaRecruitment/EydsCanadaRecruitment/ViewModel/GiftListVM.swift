//
//  GiftListVM.swift
//  EydsCanadaRecruitment
//
//  Created by Mac-09 on 17/08/23.
//

import UIKit
import Foundation

class GiftListVM: NSObject {
    let repository: GifsRepository
    var gifListData: GifListModel?
    var searchGifListData: GifListModel?
    var mainGifListData: GifListModel?
    let gifImgProvider: GifHandlerManagerProtocol;
    var operationQueue: OperationQueue?
    var isSeachApi = false
    
    init(repository: GifsRepository = GifsRepository(provider: GifsNetworkManager()), gifImgProvider: GifHandlerManagerProtocol = GifImagesHandlerManager() ) {
        self.repository = repository;
        self.gifImgProvider = gifImgProvider;
    }
    
    //MARK: API CALLS
    func getGifs(completion: @escaping () -> Void) {
        repository.getGifs {[weak self] result, error in
            if result.dataSource == .remote {
                self?.mainGifListData = nil;
                guard let resultData = result.data else { return  }
                self?.gifListData = resultData
                self?.setFavImgFromStorage(respData: result.data);
                self?.mainGifListData = self?.gifListData;
                completion()
            }
        }
    }
    
    func getSearchGifs(completion: @escaping (_ error: NetworkError?) -> Void) {
        repository.getSearchGifs {[weak self] result, error in
            if result.dataSource == .remote {
                if error == nil {
                    self?.mainGifListData = nil;
                    guard let resultData = result.data else { return  }
                    self?.searchGifListData = resultData
                    self?.setFavImgFromStorage(respData: result.data);
                    self?.mainGifListData = self?.searchGifListData;
                    completion(nil);
                } else {
                    completion(error);
                }
                
            }
        }
    }
    
    //MARK: To handle btnFav image for already selected image as fav image
    func setFavImgFromStorage(respData:GifListModel?) {
        let favGifHandlerObj = FavouriteGifHandler();
        if let gifNameArrayFrmDefaults = favGifHandlerObj.getAllFavouriteImageNameFromDefaults() {
            var giftListModel: GifListModel?
            var gifImgDetailArray: [GifData]?
            if let respData = respData {
                giftListModel = respData;
                
                
                if let gifList = respData.gifList {
                    gifImgDetailArray = gifList;
                    
                    for (index, gifObj) in gifList.enumerated() {
                        for gifName in gifNameArrayFrmDefaults {
                            if (gifObj.id == (gifName.components(separatedBy: ".")[0])) {
                                gifImgDetailArray?[index].isFavourite = true
                            }
                        }
                        
                    }
                    giftListModel?.gifList = gifImgDetailArray;
                }
                if self.isSeachApi {
                    self.searchGifListData = giftListModel;
                    self.mainGifListData = self.searchGifListData;
                } else {
                    self.gifListData = giftListModel;
                    self.mainGifListData = self.gifListData;
                }
            }
        }
    }
    
    //MARK: TABLEVIEW REQUIRED METHODS
    func numOfRow() -> Int {
        if let mainGifListData = self.mainGifListData {
            return mainGifListData.gifList?.count ?? 0
        } else {
            return 0;
        }
    }
    
    func getGifImgUrl(rowNo: Int) -> String {
        if let mainGifListData = self.mainGifListData {
            if let gifList = mainGifListData.gifList {
                return gifList[rowNo].images?.originalData?.gifUrl ?? "";
            }
            return "";
        }
        return "";
    }
    
    func setIsFavBtnIcon(rowNo: Int) -> UIImage {
        guard let favImg = UIImage(named: ImagesName.fav.rawValue) else { return UIImage() }
        guard let nonFavImg = UIImage(named: ImagesName.nonFav.rawValue) else { return UIImage() }
        
        if let mainGifListData = self.mainGifListData {
            if let gifList = mainGifListData.gifList {
                if gifList[rowNo].isFavourite ?? false {
                    return favImg;
                } else {
                    return nonFavImg;
                }
            }
        }
        return nonFavImg;
    }
    
    
    //TABLEVIEW ISFAVBUTTON ACTION
    func btnIsFavourtiteAction(rowNo: Int) {
        if let mainGifListData = self.mainGifListData {
            var gifListArray = [GifData]()
            if let gifList = mainGifListData.gifList {
                gifListArray = gifList;
                var gifImgObj = gifListArray[rowNo]
                
                if (gifImgObj.isFavourite == nil) || (gifImgObj.isFavourite == false) {
                    gifImgObj.isFavourite = true;
                    if let gifUrl = gifImgObj.images?.originalData?.gifUrl  {
                        self.getGifData(urlString: gifUrl, fileName: gifImgObj.id ?? "") // save img to doc dir func
                    }
                    
                } else {
                    gifImgObj.isFavourite = false;
                    self.removeUnFavGif(rowNo: rowNo);
                }
                gifListArray.remove(at: rowNo)
                gifListArray.insert(gifImgObj, at: rowNo);
                self.mainGifListData?.gifList = gifListArray;
                
            }
        }
    }
    
    //MARK: STORE IMAGE TO DOC DIR AND STORE IMAGE NAME TO USERDEFAULTS
    func getGifData(urlString: String, fileName: String) {
        DispatchQueue.global().async { [weak self] in
            guard let url = URL(string: urlString) else {
                return
            }
            guard let data = try? Data(contentsOf: url) else {
                return
            }
            self?.concurrentOperation(gifData: data, fileName: (fileName + ".gif"))
        }
    }
    
    func concurrentOperation(gifData: Data,fileName:String) {
        let concurrQueue = DispatchQueue(label: "saveImgQueue", attributes: .concurrent);
        concurrQueue.async {[weak self] in
            self?.saveGifArrayToDefaults(fileName: fileName)
        }
        concurrQueue.async {[weak self] in
            self?.saveGifImgDataToDocDir(gifData: gifData, fileName:fileName);
        }
    }
    
    func saveGifImgDataToDocDir(gifData: Data, fileName: String) {
        gifImgProvider.saveToDocDir(gifData: gifData, fileName: fileName)
    }
    
    func saveGifArrayToDefaults(fileName: String) {
        let favGifhandlerObj = FavouriteGifHandler()
        favGifhandlerObj.saveGifImgDataToUserDefaults(fileName: fileName);
    }
    
    //MARK: REMOVE IMAGE TO DOC DIR AND STORE IMAGE NAME TO USERDEFAULTS
    func removeUnFavGif(rowNo: Int) {
        if let mainGifListData = self.mainGifListData {
            if let gifList = mainGifListData.gifList {
                let gifName = (gifList[rowNo].id ?? "") + ".gif"
                self.removeConcurrOp(fileName: gifName)
            }
        }
    }
    
    func removeConcurrOp(fileName: String) {
        let concurrQueue = DispatchQueue(label: "removeConcurr", attributes: .concurrent);
        concurrQueue.async { [weak self] in
            self?.removeFilefromDocDir(fileName: fileName)
        }
        concurrQueue.async { [weak self] in
            self?.removeFrmUserDefaults(fileName: fileName)
        }
    }
    
    func removeFilefromDocDir(fileName: String) {
        self.gifImgProvider.deleteFileFromDocDir(fileName);
    }
    
    func removeFrmUserDefaults(fileName: String) {
        let obj = FavouriteGifHandler()
        if let gifImgArray = obj.getAllFavouriteImageNameFromDefaults() {
            var updatedGifArray = gifImgArray;
            for (index, name) in gifImgArray.enumerated() {
                if fileName == name {
                    updatedGifArray.remove(at: index);
                }
            }
            obj.removeObjFromUserDefaults(key: UserDefaultsKeys.FavouriteGifsArray.rawValue);
            obj.saveObjToUserDefaults(key: UserDefaultsKeys.FavouriteGifsArray.rawValue, data: updatedGifArray);
        }
    }
    
    //MARK: SEARCH BUTTON ACTION
    func searchBtnAction( searchTxt: String) -> Bool {
        if searchTxt.count > 0 {
            //isSearchApi set true for search api call
            self.isSeachApi = true
            searchApiParamForSearchTxt = searchTxt;
            return true;
        } else {
            //isSearchApi set false for getGif api call
            self.isSeachApi = false
            searchApiParamForSearchTxt = "";
            self.searchGifListData = nil;
            
            return false
        }
    }
}

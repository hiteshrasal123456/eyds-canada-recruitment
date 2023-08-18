//
//  GifsNetworkManager.swift
//  EydsCanadaRecruitment
//
//  Created by Mac-09 on 17/08/23.
//

import UIKit
import Foundation

class GifsNetworkManager: GifsNetworkManagerProtocol {

    func getGifs(completion: @escaping (Result<GifListModel, NetworkError>) -> Void) {
        NetworkManager.getDataModel(request: .gifImgList, modelType: GifListModel.self, completion: completion)
    }
    
    func getSearchGifs(completion: @escaping (Result<GifListModel, NetworkError>) -> Void) {
        NetworkManager.getDataModel(request: .searchList, modelType: GifListModel.self, completion: completion)
    }
    
    
}

//
//  GifsNetworkManagerProtocol.swift
//  EydsCanadaRecruitment
//
//  Created by Mac-09 on 17/08/23.
//

import Foundation

protocol GifsNetworkManagerProtocol {
    func getGifs(completion: @escaping (Result<GifListModel, NetworkError>) -> Void)
    func getSearchGifs(completion: @escaping (Result<GifListModel, NetworkError>) -> Void)
}

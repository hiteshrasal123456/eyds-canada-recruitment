//
//  GifsRepository.swift
//  EydsCanadaRecruitment
//
//  Created by Mac-09 on 17/08/23.
//

import UIKit

// viewModel -> Repository -> DB or Network
class GifsRepository {
    
    let provider: GifsNetworkManagerProtocol
    
    init(provider: GifsNetworkManagerProtocol = GifsNetworkManager()) {
        self.provider = provider
    }
    
    func getGifs(repositoryType: RepositoryType = .remote, completion: @escaping (APIResult<GifListModel>, NetworkError?) -> Void) {
        
        if repositoryType == .remote {
            fetchDataFromNetwork(completion: completion)
        }
    }
    
    func getSearchGifs(repositoryType: RepositoryType = .remote, completion: @escaping (APIResult<GifListModel>, NetworkError?) -> Void) {
        
        if repositoryType == .remote {
            fetchSearchDataFromNetwork(completion: completion)
        }
    }
   
    
    private func fetchDataFromNetwork(completion: @escaping (APIResult<GifListModel>, NetworkError?) -> Void) {
        // API Call
        provider.getGifs { result in
            switch result {
            case .success(let listOfgif):
                DispatchQueue.main.async {
                    completion(APIResult(dataSource: .remote, data: listOfgif), nil)
                }
            case .failure(let error):
                completion(APIResult(dataSource: .remote, data: nil), error)
            }
        }
    }
    
    private func fetchSearchDataFromNetwork(completion: @escaping (APIResult<GifListModel>, NetworkError?) -> Void) {
        // API Call
        provider.getSearchGifs { result in
            switch result {
            case .success(let listOfgif):
                DispatchQueue.main.async {
                    completion(APIResult(dataSource: .remote, data: listOfgif), nil)
                }
            case .failure(let error):
                completion(APIResult(dataSource: .remote, data: nil), error)
            }
        }
    }
    
}


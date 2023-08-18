//
//  NetworkOperation.swift
//  EydsCanadaRecruitment
//
//  Created by Mac-09 on 17/08/23.
//

import Foundation

class NetworkOperation: Operation {
    var isRunning: Bool = false
    
    var dataTask: URLSessionDataTask?
    
    var completion: ((Data?, HTTPURLResponse?, Error?) -> Void)?
    
    let request: URLRequest
    
    
    init(request: URLRequest) {
        self.request = request
        super.init()
    }
    
    override func start() {
        dataTask = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
            self.completion?(data, response as? HTTPURLResponse, error)
        })
        dataTask?.resume()
    }
    
    override func cancel() {
        dataTask?.cancel()
    }
}

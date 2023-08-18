//
//  NetworkManager.swift
//  EydsCanadaRecruitment
//
//  Created by Mac-09 on 17/08/23.
//

import Foundation



enum RepositoryType {
    case remote // API call
    
}

class NetworkManager {
    private static var queue: OperationQueue = {
        let operationQueue = OperationQueue()
        operationQueue.maxConcurrentOperationCount = 6
        return operationQueue
    }()
        
    static func getDataModel<T: Codable>(request: APIEndPoint, modelType: T.Type, completion: @escaping (Result<T, NetworkError>) -> Void) -> NetworkOperation? {
        
        
        let operation = NetworkOperation(request: request.request)
        
        operation.completion = { (data, response, error) in
         
            if let data = data {
                do {
                    let respDict = try JSONSerialization.jsonObject(with: data);
                  
                    let model = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(model))
                } catch let error {
                    completion(.failure(NetworkError(response: nil, data: nil, error: error)))
                }
            } else {
                // error
                completion(.failure(NetworkError(response: response, data: data, error: error)))
            }
        }
        queue.addOperation(operation)
        
        return operation
    }
    
    static func dataRequest(request: URLRequest, completion: @escaping (Result<Bool, NetworkError>) -> Void) -> NetworkOperation? {
        
        
        let operation = NetworkOperation(request: request)
        operation.completion = { data, response, error in
            if let statusCode = response?.statusCode, statusCode >= 200 && statusCode <= 299 {
                completion(.success(true))
                return
            }
            completion(.failure(NetworkError(response: response, data: data, error: error)))
        }
        queue.addOperation(operation)
        
        return operation
    }
}

enum ErrorType: Int {
    case serverError = 404
    case requestTimeOut = -1001
    case parsingError = -1002
    case requestCancelled = -999
    case noInternetConnection = -1009
    case transportSecurityPolicyRequired = -1022
    case unknown = 0
}

class NetworkError: Error {
    let data: Data?
    let error: Error?
    let response: HTTPURLResponse?
    let errorType: ErrorType
    
    init(response: HTTPURLResponse?, data: Data?, error: Error?) {
        self.response = response
        self.error = error
        self.data = data
        if let statusCode = response?.statusCode, let errorType = ErrorType(rawValue: statusCode) {
            self.errorType = errorType
        } else if let errorCode = (error as NSError?)?.code, let errorType = ErrorType(rawValue: errorCode) {
            self.errorType = errorType
        } else {
            self.errorType = .unknown
        }
    }
}

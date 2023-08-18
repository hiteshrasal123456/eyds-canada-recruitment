//
//  ApiEndPoints.swift
//  EydsCanadaRecruitment
//
//  Created by Mac-09 on 17/08/23.
//

import Foundation

typealias Headers = [String: String]

enum Environment {
    
    static var apiBaseURL: String {
        return  "https://api.giphy.com/v1/gifs/"
    }
    
}

enum HTTPMethod: String {
    case get
    case post
    case put
    case delete
}

// Enum with URL without parameters but with request body. also headers can be customized
// below Two ways you can put generics
//enum APIEndPoint<T: Codable> {
enum APIEndPoint {
    
    // MARK: - cases
    case gifImgList
    case searchList
    
    // MARK: - Properties
    var request: URLRequest {
        var request = URLRequest(url: url)
        
        request.addHeaders(headers)
        request.httpMethod = httpMethod.rawValue
        
        if let requestBody = requestBody {
            request.httpBody = requestBody
        }
        
        return request
    }
    
    private var url: URL {
        return URL(string: (Environment.apiBaseURL + path))!
    }

    private var path: String {
        switch self {
        case .gifImgList:
            return "trending?api_key=g0sdtrnp5JljngLROfQey7d95JPx3p2v&limit=20&offset=5&rating&random_id=e826c9fc5c929e0d6c6d423841a282aa&bundle=messaging_non_clips"
        case .searchList:
            return "search?api_key=g0sdtrnp5JljngLROfQey7d95JPx3p2v&q=\(searchApiParamForSearchTxt)&limit=20&offset=5&rating=g&lang=en&random_id=e826c9fc5c929e0d6c6d423841a282aa&bundle=messaging_non_clips"
        
        }
    }
    
    private var httpMethod: HTTPMethod {
        switch self {
        case .gifImgList:
            return .get
        case .searchList:
            return .get
        }
    }
    
    private var requestBody: Data? {
        // prepare request body
        switch self {
        case .gifImgList, .searchList:
            return nil
        }
    }
    
    private var headers: Headers {
        // custimze headers here
        switch self {
        default:
            return [ "Content-Type":"application/json"]
        }
    }
}




fileprivate extension URLRequest {
    mutating func addHeaders(_ headers: Headers) {
        headers.forEach { header, value in
            addValue(value, forHTTPHeaderField: header)
        }
    }
}

//getRequest Params
var searchApiParamForSearchTxt = ""


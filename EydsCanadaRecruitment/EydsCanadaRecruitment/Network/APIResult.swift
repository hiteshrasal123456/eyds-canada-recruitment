//
//  APIResult.swift
//  EydsCanadaRecruitment
//
//  Created by Mac-09 on 17/08/23.
//

import UIKit
import Foundation

class APIResult<T: Codable> {
    var dataSource: RepositoryType = .remote
    var data: T?
    
    init(dataSource: RepositoryType, data: T?) {
        self.dataSource = dataSource
        self.data = data
    }
}

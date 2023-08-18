//
//  GifHandlerManagerProtocol.swift
//  EydsCanadaRecruitment
//
//  Created by Mac-09 on 18/08/23.
//

import Foundation
import UIKit

protocol GifHandlerManagerProtocol {
    func saveToDocDir(gifData: Data, fileName: String)
    func readFromDocDir(fileName: String) -> UIImage?
    func deleteFileFromDocDir(_ fileToDelete: String)
}

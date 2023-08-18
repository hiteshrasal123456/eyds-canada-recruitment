//
//  GifImagesHandlerManager.swift
//  EydsCanadaRecruitment
//
//  Created by Mac-09 on 18/08/23.
//

import UIKit

class GifImagesHandlerManager:GifHandlerManagerProtocol {

    func saveToDocDir(gifData: Data, fileName: String)  {
        do {
            // get the documents directory url
            let documentsDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            print("documentsDirectory:", documentsDirectory.path)
            
            let fileURL = documentsDirectory.appendingPathComponent(fileName)
          
            if !FileManager.default.fileExists(atPath: fileURL.path) {
                // writes the image data to disk
                try gifData.write(to: fileURL)
            }
        } catch {
            print("error:", error)
        }
    }
    
    
    func readFromDocDir(fileName: String) -> UIImage? {
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let localUrl = documentDirectory!.appendingPathComponent(fileName);

    if FileManager.default.fileExists(atPath: localUrl.path) {
        do {
            let data = try Data(contentsOf: localUrl)
                return UIImage.gif(data: data)
        } catch let error {
            print("failed to read the file****** \(error)");

            return nil
        }
    } else {
        return nil;
    }
  }
    
    func deleteFileFromDocDir(_ fileToDelete: String) {
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let localUrl = documentDirectory!.appendingPathComponent(fileToDelete);
            
            
            do {
                try FileManager.default.removeItem(at: localUrl)
                print("Image has been deleted")
            } catch {
                print(error)
            }
        }
}

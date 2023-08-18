//
//  UserDefaultsManager.swift
//  EydsCanadaRecruitment
//
//  Created by Mac-09 on 18/08/23.
//

import UIKit
class UserDefaultsManager {

    func saveDataToDefaults(data: Any, key: String) {
        UserDefaults.standard.set(data, forKey: key);
        UserDefaults.standard.synchronize();
    }
    
    func getDataFromDefaults(key: String) -> Any? {
        return UserDefaults.standard.object(forKey: key);
    }
    
    func removeDataFromDefaults(key: String) {
        UserDefaults.standard.removeObject(forKey: key)
        UserDefaults.standard.synchronize();
    }
}

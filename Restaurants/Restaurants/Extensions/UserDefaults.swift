//
//  UserDefaults.swift
//  Restaurants
//
//  Created by Abdullah Bayraktar on 22.08.20.
//  Copyright © 2020 Abdullah Bayraktar. All rights reserved.
//

import Foundation

extension UserDefaults {
    
    /// Returns an object associated with specified key
    /// - Parameter key: Key for user defaults
    /// - Returns: Object for the corresponding key
    static func getArray(forKey key: String) -> Any? {
        guard let array = standard.array(forKey: key) else {
            return nil
        }
        
        return array
    }
    
    /// Stores array with specified key
    /// - Parameters:
    ///   - object: Array to be stored
    ///   - key: Key for user defaults
    static func setArray(_ array: Any, for key: String) {
        standard.set(array, forKey: key)
    }
}

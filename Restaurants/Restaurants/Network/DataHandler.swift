//
//  DataHandler.swift
//  Restaurants
//
//  Created by Abdullah Bayraktar on 19.08.2020.
//  Copyright © 2020 Abdullah Bayraktar. All rights reserved.
//

import Foundation

private enum Constant {
    static let fileExtension = "json"
}

final class DataHandler {
    
    static func readLocalJSONFile(withName name: String) -> Data? {
        do {
            if let bundlePath = Bundle.main.path(forResource: name, ofType: Constant.fileExtension),
                let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                return jsonData
            }
        } catch {
            print(error)
        }
        
        return nil
    }
}

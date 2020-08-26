//
//  RestaurantsDataController.swift
//  Restaurants
//
//  Created by Abdullah Bayraktar on 19.08.2020.
//  Copyright © 2020 Abdullah Bayraktar. All rights reserved.
//

import Foundation

private enum Constant {
    static let fileName = "restaurants"
}

final class RestaurantsDataController: RestaurantsDataProtocol {
    
    func retrieveRestaurants(completion: @escaping RestaurantsCompletion) {
        do {
            if let data = DataHandler.readLocalJSONFile(withName: Constant.fileName),
                let restaurants = try JSONDecoder().decode(RestaurantsListResponse.self, from: data).restaurants {
                completion(restaurants, nil)
            }
        } catch {
            completion(nil, error)
        }
    }
}

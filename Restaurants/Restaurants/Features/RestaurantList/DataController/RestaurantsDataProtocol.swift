//
//  RestaurantsDataProtocol.swift
//  Restaurants
//
//  Created by Abdullah Bayraktar on 19.08.2020.
//  Copyright © 2020 Abdullah Bayraktar. All rights reserved.
//

import Foundation

typealias RestaurantsCompletion = ([Restaurant]?, Error?) -> Void

protocol RestaurantsDataProtocol {
    
    /// Retrieves list of restaurants
    /// - Parameter completion: Completion block
    func retrieveRestaurants(completion: @escaping RestaurantsCompletion)
}

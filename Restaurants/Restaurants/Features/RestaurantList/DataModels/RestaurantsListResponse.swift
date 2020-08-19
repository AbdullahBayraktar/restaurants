//
//  RestaurantsListResponse.swift
//  Restaurants
//
//  Created by Abdullah Bayraktar on 19.08.2020.
//  Copyright © 2020 Abdullah Bayraktar. All rights reserved.
//

import Foundation

struct RestaurantsListResponse: Decodable {
    let restaurants: [Restaurant]?
}

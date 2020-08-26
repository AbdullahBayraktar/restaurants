//
//  RestaurantsDummyDataController.swift
//  RestaurantsTests
//
//  Created by Abdullah Bayraktar on 26.08.20.
//  Copyright © 2020 Abdullah Bayraktar. All rights reserved.
//

import XCTest
@testable import Restaurants

final class RestaurantsDummyDataController: RestaurantsDataProtocol {
    
    func retrieveRestaurants(completion: @escaping RestaurantsCompletion) {
        
        let json = """
             {
               "restaurants": [{
                   "name": "Tanoshii Sushi",
                   "status": "open",
                   "sortingValues": {
                       "bestMatch": 0.0,
                       "newest": 96.0,
                       "ratingAverage": 4.5,
                       "distance": 1190,
                       "popularity": 17.0,
                       "averageProductPrice": 1536,
                       "deliveryCosts": 200,
                       "minCost": 1000
                   }
               }, {
                   "name": "Tandoori Express",
                   "status": "closed",
                   "sortingValues": {
                       "bestMatch": 1.0,
                       "newest": 266.0,
                       "ratingAverage": 4.5,
                       "distance": 2308,
                       "popularity": 123.0,
                       "averageProductPrice": 1146,
                       "deliveryCosts": 150,
                       "minCost": 1300
                   }
               }, {
                      "name": "Zenzai Sushi",
                      "status": "closed",
                      "sortingValues": {
                          "bestMatch": 13.0,
                          "newest": 155.0,
                          "ratingAverage": 4.0,
                          "distance": 2911,
                          "popularity": 36.0,
                          "averageProductPrice": 1579,
                          "deliveryCosts": 0,
                          "minCost": 2000
                      }
                  }]
        }
        """.data(using: .utf8)!
        if let restaurants = try? JSONDecoder().decode(RestaurantsListResponse.self, from: json).restaurants {
            completion(restaurants, nil)
        }
    }
}


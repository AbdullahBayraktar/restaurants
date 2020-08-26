//
//  SortingValues.swift
//  Restaurants
//
//  Created by Abdullah Bayraktar on 19.08.2020.
//  Copyright © 2020 Abdullah Bayraktar. All rights reserved.
//

struct SortingValues: Decodable {
    let bestMatch: Double
    let newest: Double
    let ratingAverage: Double
    let distance: Int
    let popularity: Double
    let averageProductPrice: Int
    let deliveryCosts: Int
    let minCost: Int
}

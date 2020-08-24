//
//  SortOption.swift
//  Restaurants
//
//  Created by Abdullah Bayraktar on 23.08.20.
//  Copyright © 2020 Abdullah Bayraktar. All rights reserved.
//

enum SortOption: String, CaseIterable {
    case bestMatch = "Best match"
    case newest = "Newest"
    case ratingAverage = "Rating average"
    case distance = "Distance"
    case popularity = "Popularity"
    case averageProductPrice = "Average product price"
    case deliveryCosts = "Delivery costs"
    case minimumCost = "Minimum cost"
}

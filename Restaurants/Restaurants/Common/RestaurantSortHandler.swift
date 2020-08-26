//
//  RestaurantSortHandler.swift
//  Restaurants
//
//  Created by Abdullah Bayraktar on 26.08.20.
//  Copyright © 2020 Abdullah Bayraktar. All rights reserved.
//

import Foundation

final class RestaurantSortHandler: RestaurantSortable {
    
    static func sortAccordingToOpeningState(_ restaurants: [Restaurant]) -> [Restaurant] {
        return restaurants.sorted(by: { $0.status < $1.status } )
    }
    
    static func sortRestaurants(_ restaurants: [Restaurant], sortOption: SortOption) -> [Restaurant] {
        switch sortOption {
        case .bestMatch:
            return restaurants.sorted(by: { $0.sortingValues.bestMatch > $1.sortingValues.bestMatch })
        case .newest:
            return restaurants.sorted(by: { $0.sortingValues.newest > $1.sortingValues.newest })
        case .ratingAverage:
            return restaurants.sorted(by: { $0.sortingValues.ratingAverage > $1.sortingValues.ratingAverage })
        case .distance:
            return restaurants.sorted(by: { $0.sortingValues.distance < $1.sortingValues.distance })
        case .popularity:
            return restaurants.sorted(by: { $0.sortingValues.popularity > $1.sortingValues.popularity })
        case .averageProductPrice:
            return restaurants.sorted(by: { $0.sortingValues.averageProductPrice < $1.sortingValues.averageProductPrice })
        case .deliveryCosts:
            return restaurants.sorted(by: { $0.sortingValues.deliveryCosts < $1.sortingValues.deliveryCosts })
        case .minimumCost:
            return restaurants.sorted(by: { $0.sortingValues.minCost < $1.sortingValues.minCost })
        }
    }
    
    static func sortingValueText(for sortOption: SortOption, sortingValues: SortingValues) -> String {
        
        var sortingValue: Any
        
        switch sortOption {
        case .bestMatch:
          sortingValue = sortingValues.bestMatch
        case .newest:
            sortingValue = sortingValues.newest
        case .ratingAverage:
            sortingValue = sortingValues.newest
        case .distance:
            sortingValue = sortingValues.distance
        case .popularity:
            sortingValue = sortingValues.popularity
        case .averageProductPrice:
            sortingValue = sortingValues.averageProductPrice
        case .deliveryCosts:
            sortingValue = sortingValues.deliveryCosts
        case .minimumCost:
            sortingValue = sortingValues.minCost
        }
        
        return String(describing: sortingValue)
    }
}

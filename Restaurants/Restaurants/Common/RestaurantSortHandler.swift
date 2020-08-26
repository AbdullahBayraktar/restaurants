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
        
        var displayValue: String
        
        switch sortOption {
        case .bestMatch:
            displayValue = String(describing: sortingValues.bestMatch)
        case .newest:
            displayValue = String(describing: sortingValues.newest)
        case .ratingAverage:
            displayValue = String(describing: sortingValues.ratingAverage)
        case .distance:
            displayValue = MeasurementFormatter.displayText(for: sortingValues.distance)
        case .popularity:
            displayValue = String(describing: sortingValues.popularity)
        case .averageProductPrice:
            displayValue = sortingValues.averageProductPrice.currencyDisplayText()
        case .deliveryCosts:
            displayValue = sortingValues.deliveryCosts.currencyDisplayText()
        case .minimumCost:
            displayValue = sortingValues.minCost.currencyDisplayText()
        }
        
        return displayValue
    }
}

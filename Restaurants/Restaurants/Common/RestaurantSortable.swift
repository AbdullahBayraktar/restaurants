//
//  RestaurantSortable.swift
//  Restaurants
//
//  Created by Abdullah Bayraktar on 26.08.20.
//  Copyright © 2020 Abdullah Bayraktar. All rights reserved.
//

protocol RestaurantSortable {
    
    /// Sort restaurants according to opening state (order: open, order ahead then closed)
    /// - Parameter restaurants: Restaurants list
    /// - Returns: Sorted list of restaurants
    static func sortAccordingToOpeningState(_ restaurants: [Restaurant]) -> [Restaurant]
    
    /// Sort restaurants according to given sort option
    /// - Parameters:
    ///   - restaurants: Restaurants list
    ///   - sortOption: Chosen sort method
    /// - Returns: Sorted list of restaurants
    static func sortRestaurants(_ restaurants: [Restaurant], sortOption: SortOption) -> [Restaurant]
    
    /// Returns sorting value text for given sort option
    /// - Parameters:
    ///   - sortOption: Chosen sort method
    ///   - sortingValues: Sorting values
    /// - Returns: Sorting value text
    static func sortingValueText(for sortOption: SortOption, sortingValues: SortingValues) -> String
}

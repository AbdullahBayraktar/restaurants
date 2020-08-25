//
//  RestaurantsListState.swift
//  Restaurants
//
//  Created by Abdullah Bayraktar on 21.08.2020.
//  Copyright © 2020 Abdullah Bayraktar. All rights reserved.
//

final class RestaurantsListState {

    /// Possible changes
    enum Change {
        case restaurants(Bool)
        case filteredRestaurants(Bool)
    }

    /// Triggered when change occured
    var onChange: ((RestaurantsListState.Change) -> Void)?
    
    /// Restaurants updated state
    var areRestaurantsUpdated: Bool = false {
        didSet { onChange?(.restaurants(areRestaurantsUpdated)) }
    }
    
    /// Restaurants filtered state
    var areRestaurantsFiltered = false {
        didSet { onChange?(.filteredRestaurants(areRestaurantsFiltered)) }
    }
}

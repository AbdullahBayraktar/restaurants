//
//  RestaurantsListViewModel.swift
//  Restaurants
//
//  Created by Abdullah Bayraktar on 21.08.2020.
//  Copyright © 2020 Abdullah Bayraktar. All rights reserved.
//

import Foundation

typealias RestaurantsFetchCompletion = ([Restaurant], Bool) -> Void

final class RestaurantsListViewModel {
    
    /// State
    private let state = RestaurantsListState()
    
    /// State change handler to trigger
    var stateChangeHandler: ((RestaurantsListState.Change) -> Void)? {
        get { return state.onChange }
        set { state.onChange = newValue }
    }

    /// Data controller
    private var dataController: RestaurantsDataProtocol

    /// List of restaurants
    private var restaurants: [Restaurant]?

    /// Count of the restaurants
    var restaurantsCount: Int {
        return restaurants?.count ?? 0
    }
    
    /// Initializes a new view model
    /// - Parameter dataController: Provided data controller
    init(with dataController: RestaurantsDataProtocol) {
        self.dataController = dataController
    }
}

// MARK: - Accessors

extension RestaurantsListViewModel {
    
    /// Returns restaurants at given index
    ///
    /// - Parameter index: Index of the requested restaurants
    /// - Returns: Restaurants if exists
    func restaurant(at index: Int) -> Restaurant? {
        guard index < restaurantsCount,
            let restaurants = restaurants else {
                return nil
        }

        return restaurants[index]
    }
}

// MARK: - Network

extension RestaurantsListViewModel {
    
    /// Fetches restaurants
    func retrieveRestaurants() {
        
        dataController.retrieveRestaurants { [weak self] (restaurants, error) in
            guard let strongSelf = self,
                let restaurants = restaurants else {
                return
            }
            
            strongSelf.restaurants = restaurants
            strongSelf.state.areRestaurantsAvailable = restaurants.count > 0
        }
    }
}

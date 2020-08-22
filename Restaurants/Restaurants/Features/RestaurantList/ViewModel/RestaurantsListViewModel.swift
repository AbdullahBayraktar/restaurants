//
//  RestaurantsListViewModel.swift
//  Restaurants
//
//  Created by Abdullah Bayraktar on 21.08.2020.
//  Copyright © 2020 Abdullah Bayraktar. All rights reserved.
//

import Foundation

typealias RestaurantsFetchCompletion = ([Restaurant], Bool) -> Void
typealias RestaurantInfo = (restaurant: Restaurant, isFavourited: Bool)

final class RestaurantsListViewModel {
    
    private enum UserDefaultsKey {
        static let favouriteRestaurants = "FavouriteRestaurantsKey"
    }
    
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
    
    /// List of favourited restaurant names
    private var storedFavouritedRestaurantNames: [String]? {
        get {
            UserDefaults.getArray(forKey: UserDefaultsKey.favouriteRestaurants) as? [String]
        }
        set {
            UserDefaults.setArray(newValue as Any, for: UserDefaultsKey.favouriteRestaurants)
        }
    }

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
    
    /// Returns restaurant info at given index
    ///
    /// - Parameter index: Index of the requested restaurants
    /// - Returns: Restaurants if exists
    func restaurantInfo(at index: Int) -> RestaurantInfo? {
        guard index < restaurantsCount,
            let restaurants = restaurants else {
                return nil
        }
        let restaurant = restaurants[index]
        let isFavourited = storedFavouritedRestaurantNames?.contains(restaurant.name) ?? false
        return RestaurantInfo(restaurant, isFavourited)
    }
}

// MARK: - Modifiers

extension RestaurantsListViewModel {
    
    func togglefavouriteRestaurant(name: String) {
        guard var updatedRestaurantNames = storedFavouritedRestaurantNames else {
            storedFavouritedRestaurantNames = [name]
            return
        }
        
        if let index = storedFavouritedRestaurantNames?.firstIndex(where: { $0 == name }) {
            updatedRestaurantNames.remove(at: index)
        }
        else {
            updatedRestaurantNames.append(name)
        }

        storedFavouritedRestaurantNames = updatedRestaurantNames
    }
    
    func sortRestaurants() {
        guard let restaurants = restaurants else {
            return
        }
        
        let groups = restaurants.separate(predicate: { (restaurant) -> Bool in
            storedFavouritedRestaurantNames?.contains(restaurant.name) ?? false
        })
        
        let favouriteRestaurants = sortAccordingToOpeningState(groups.matching)
        let otherRestaurants = sortAccordingToOpeningState(groups.notMatching)
        
        self.restaurants = [favouriteRestaurants, otherRestaurants].flatMap({ (restaurant) in
            return restaurant
        })
    }
    
    func sortAccordingToOpeningState(_ restaurants: [Restaurant]) -> [Restaurant] {
        return restaurants.sorted(by: { $0.status < $1.status } )
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
            strongSelf.sortRestaurants()
            strongSelf.state.areRestaurantsAvailable = restaurants.count > 0
        }
    }
}

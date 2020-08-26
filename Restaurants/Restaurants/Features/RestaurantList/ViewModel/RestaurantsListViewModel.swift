//
//  RestaurantsListViewModel.swift
//  Restaurants
//
//  Created by Abdullah Bayraktar on 21.08.2020.
//  Copyright © 2020 Abdullah Bayraktar. All rights reserved.
//

import Foundation

typealias RestaurantsFetchCompletion = ([Restaurant], Bool) -> Void
typealias RestaurantInfo = (restaurant: Restaurant, isFavourited: Bool, sortValue: String)

final class RestaurantsListViewModel {
    
    /// Enums
    private enum UserDefaultsKey {
        static let favouriteRestaurants = "FavouriteRestaurantsKey"
    }
    
    // MARK: - Stored properties
    
    /// State
    private let state = RestaurantsListState()
    
    /// Data controller
    private var dataController: RestaurantsDataProtocol

    /// List of filtered restaurants
    private var filteredRestaurants: [Restaurant]?
    
    /// List of retrieved and sorted restaurants
    private var retrievedRestaurants: [Restaurant]?
    
    /// Determines whether list is filtered
    private var isFiltering: Bool = false
    
    // MARK: - Computed properties

    /// List of restaurants
    private var restaurants: [Restaurant]? {
        get {
            isFiltering ? filteredRestaurants : retrievedRestaurants
        }
        set {
            if isFiltering {
                filteredRestaurants = newValue
                state.areRestaurantsFiltered = true
            }
            else {
                retrievedRestaurants = newValue
                state.areRestaurantsUpdated = true
            }
        }
    }
    
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
        if isFiltering {
            return filteredRestaurants?.count ?? 0
        } else {
            return restaurants?.count ?? 0
        }
    }
    
    /// Current selected sort option
    var selectedSortOption: SortOption = .bestMatch {
        didSet {
            restaurants = sortRestaurantsList(restaurants ?? [], sortOption: selectedSortOption)
        }
    }
    
    /// State change handler to trigger
    var stateChangeHandler: ((RestaurantsListState.Change) -> Void)? {
        get { return state.onChange }
        set { state.onChange = newValue }
    }
    
    // MARK: - Lifecycle
    
    /// Initializes a new view model
    /// - Parameter dataController: Provided data controller
    init(with dataController: RestaurantsDataProtocol) {
        self.dataController = dataController
    }
}

// MARK: - Accessors

extension RestaurantsListViewModel {
    
    /// Returns restaurant info for restaurant at given index
    ///
    /// - Parameter index: Index of the requested restaurant
    /// - Returns: Restaurant info if exists
    func restaurantInfo(at index: Int) -> RestaurantInfo? {
        guard index < restaurantsCount,
            let restaurants = restaurants else {
                return nil
        }
        
        let restaurant = restaurants[index]
        let isFavourited = storedFavouritedRestaurantNames?.contains(restaurant.name) ?? false
        let sortValue = RestaurantSortHandler.sortingValueText(
            for: selectedSortOption,
            sortingValues: restaurant.sortingValues)
        
        return RestaurantInfo(restaurant, isFavourited, sortValue)
    }
}

// MARK: - Favourite

extension RestaurantsListViewModel {
    
    /// Favourite/unfavourite restaurant with the given name
    /// - Parameter name: Restaurant name
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
}

// MARK: - Sort

extension RestaurantsListViewModel {
    
    /// Sorts restaurants with the provided sort option
    /// - Parameters:
    ///   - restaurants: Restaurants to be sorted
    ///   - sortOption: Chosen sort option
    /// - Returns: List of sorted restaurants
    func sortRestaurantsList(_ restaurants: [Restaurant], sortOption: SortOption) -> [Restaurant]  {
        
        let groups = restaurants.separate(predicate: { (restaurant) -> Bool in
            storedFavouritedRestaurantNames?.contains(restaurant.name) ?? false
        })
        
        // favourite restaurants list
        var favouritedRestaurants = RestaurantSortHandler.sortRestaurants(groups.matching, sortOption: sortOption)
        favouritedRestaurants = RestaurantSortHandler.sortAccordingToOpeningState(favouritedRestaurants)
        
        // unfavourite restaurants list
        var unfavouritedRestaurants = RestaurantSortHandler.sortRestaurants(groups.notMatching, sortOption: sortOption)
        unfavouritedRestaurants = RestaurantSortHandler.sortAccordingToOpeningState(unfavouritedRestaurants)
        
        let sortedRestaurants = [favouritedRestaurants, unfavouritedRestaurants].flatMap({ (restaurant) in
            return restaurant
        })
        
        return sortedRestaurants
    }
}

// MARK: - Filter

extension RestaurantsListViewModel {
    
    /// Filters restaurants with given search text
    /// - Parameter searchText: Text to be looked for
    func filterRestaurants(forSearchText searchText: String?) {
        guard let searchText = searchText else {
            return
        }
        
        isFiltering = !searchText.isEmpty
        
        if isFiltering {
            restaurants = retrievedRestaurants?.filter({ (restaurant) -> Bool in
                restaurant.name.lowercased().contains(searchText.lowercased())
            })
        }
        else {
            restaurants = retrievedRestaurants
        }
    }
}

// MARK: - Data

extension RestaurantsListViewModel {
    
    /// Fetches restaurants
    func retrieveRestaurants() {
        
        dataController.retrieveRestaurants { [weak self] (restaurants, error) in
            guard let strongSelf = self,
                let restaurants = restaurants,
                !restaurants.isEmpty else {
                return
            }
            
            strongSelf.restaurants = strongSelf.sortRestaurantsList(restaurants, sortOption: strongSelf.selectedSortOption)
        }
    }
}

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

    /// List of filtered restaurants
    private var filteredRestaurants: [Restaurant]?
    
    /// List of retrieved restaurants
    private var retrievedRestaurants: [Restaurant]?
    
    /// Determines whether list is filtered
    private var isFiltering: Bool = false
    
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
        let sortValue = sortingValueText(for: selectedSortOption, sortingValues: restaurant.sortingValues)
        return RestaurantInfo(restaurant, isFavourited, sortValue)
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
    
    func sortRestaurantsList(_ restaurants: [Restaurant], sortOption: SortOption) -> [Restaurant]  {
        
        let groups = restaurants.separate(predicate: { (restaurant) -> Bool in
            storedFavouritedRestaurantNames?.contains(restaurant.name) ?? false
        })
        
        var favouriteRestaurants = sortRestaurants(groups.matching, sortOption: sortOption)
        favouriteRestaurants = sortAccordingToOpeningState(favouriteRestaurants)
        
        var otherRestaurants = sortRestaurants(groups.notMatching, sortOption: sortOption)
        otherRestaurants = sortAccordingToOpeningState(otherRestaurants)
        
        let sortedRestaurants = [favouriteRestaurants, otherRestaurants].flatMap({ (restaurant) in
            return restaurant
        })
        
        return sortedRestaurants
    }
    
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

// MARK: - Sorting

private extension RestaurantsListViewModel {
    
    func sortAccordingToOpeningState(_ restaurants: [Restaurant]) -> [Restaurant] {
        return restaurants.sorted(by: { $0.status < $1.status } )
    }
    
    func sortRestaurants(_ restaurants: [Restaurant], sortOption: SortOption) -> [Restaurant] {
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
    
    func sortingValueText(for sortOption: SortOption, sortingValues: SortingValues) -> String {
        
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

// MARK: - Network

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

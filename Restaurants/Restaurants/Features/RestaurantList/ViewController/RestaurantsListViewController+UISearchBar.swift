//
//  RestaurantsListViewController+UISearchBar.swift
//  Restaurants
//
//  Created by Abdullah Bayraktar on 25.08.20.
//  Copyright © 2020 Abdullah Bayraktar. All rights reserved.
//

import UIKit

// MARK: - UISearchResultsUpdating

extension RestaurantsListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        viewModel.filterRestaurants(forSearchText: searchBar.text)
    }
}

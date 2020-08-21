//
//  RestaurantsListViewController+UITableViewDataSource.swift
//  Restaurants
//
//  Created by Abdullah Bayraktar on 21.08.2020.
//  Copyright © 2020 Abdullah Bayraktar. All rights reserved.
//

import UIKit

// MARK: - UITableViewDataSource

extension RestaurantsListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return viewModel.restaurantsCount
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RestaurantsTableViewCell.className, for: indexPath) as!
        RestaurantsTableViewCell

        guard let restaurant = viewModel.restaurant(at: indexPath.row) else {
            return cell
        }

        cell.configure(with: restaurant)
        
        return cell
    }
}

//
//  RestaurantsListViewController+UITableViewDelegate.swift
//  Restaurants
//
//  Created by Abdullah Bayraktar on 21.08.2020.
//  Copyright © 2020 Abdullah Bayraktar. All rights reserved.
//

import UIKit

private enum TableView {
    static let rowHeight: CGFloat = 160
}

// MARK: - UITableViewDelegate

extension RestaurantsListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return TableView.rowHeight
    }
}

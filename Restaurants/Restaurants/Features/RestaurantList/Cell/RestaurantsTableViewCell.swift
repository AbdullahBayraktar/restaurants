//
//  RestaurantsTableViewCell.swift
//  Restaurants
//
//  Created by Abdullah Bayraktar on 21.08.2020.
//  Copyright © 2020 Abdullah Bayraktar. All rights reserved.
//

import UIKit

final class RestaurantsTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var largeImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var headlineLabel: UILabel!
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()

        applyStyling()
    }

    // MARK: - Views
    
    /// Configures cell with the given parameters
    /// - Parameter restaurant: Restaurant data model
    func configure(with restaurant: Restaurant) {
        
       // TODO: Configure cell
    }

}

// MARK: - Styling

private extension RestaurantsTableViewCell {
    func applyStyling() {
        selectionStyle = .none
    }
}

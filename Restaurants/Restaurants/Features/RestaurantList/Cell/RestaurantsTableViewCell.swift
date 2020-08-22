//
//  RestaurantsTableViewCell.swift
//  Restaurants
//
//  Created by Abdullah Bayraktar on 21.08.2020.
//  Copyright © 2020 Abdullah Bayraktar. All rights reserved.
//

import UIKit

protocol RestaurantsTableViewCellDelegate: class {
    /// Notifies when favourite button tapped
    /// - Parameters:
    ///   - cell: Restaurants table view cell
    ///   - restaurantName: Name for restaurant
    func restaurantsTableViewCellDidTapFavourite(_ cell: UITableViewCell, restaurantName: String)
}

final class RestaurantsTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var statusLabel: UILabel!
//    @IBOutlet private weak var sortValueLabel: UILabel!
    @IBOutlet private weak var favouriteButton: UIButton!

    /// Properties
    
    private var restaurantName: String?
    private var isFavourite: Bool = false
    
    /// Delegate
    weak var delegate: RestaurantsTableViewCellDelegate?
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()

        applyStyling()
    }

    // MARK: - Views
    
    /// Configures cell with the given parameters
    /// - Parameter info: Restaurant info tuple
    /// - Parameter delegate:
    func configure(
        info: RestaurantInfo,
        delegate: RestaurantsTableViewCellDelegate) {
        
        let restaurant = info.restaurant
        
        restaurantName = restaurant.name
        isFavourite = info.isFavourited
        self.delegate = delegate
        
        nameLabel.text = restaurant.name
        statusLabel.text = restaurant.status.rawValue
        
        applyStylingForFavouriteButton(isFavourite: info.isFavourited)
    }
}

// MARK: - Styling

private extension RestaurantsTableViewCell {
    func applyStyling() {
        selectionStyle = .none
    }

    func applyStylingForFavouriteButton(isFavourite: Bool) {
        let image = UIImage.init(systemName: isFavourite ? "suit.heart.fill" : "suit.heart")
        favouriteButton.setImage(image, for: .normal)
    }
}

// MARK: - Actions

private extension RestaurantsTableViewCell {
    
    @IBAction func favouriteButtonTapped(_ sender: UIButton) {
        
        guard let restaurantName = restaurantName else {
            return
        }
        
        isFavourite = !isFavourite
        applyStylingForFavouriteButton(isFavourite: isFavourite)

        delegate?.restaurantsTableViewCellDidTapFavourite(self, restaurantName: restaurantName)
    }
}

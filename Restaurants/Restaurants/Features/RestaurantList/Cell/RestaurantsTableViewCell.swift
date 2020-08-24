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
    @IBOutlet private weak var sortValueLabel: UILabel!
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
    /// - info: Restaurant info tuple
    /// - sortOption: Selected sorting option
    /// - delegate: Restaurants table view cell delegate
    func configure(
        info: RestaurantInfo,
        sortOption: SortOption,
        delegate: RestaurantsTableViewCellDelegate) {
        
        let restaurant = info.restaurant
        
        restaurantName = restaurant.name
        isFavourite = info.isFavourited
        self.delegate = delegate
        
        nameLabel.text = restaurant.name
        statusLabel.text = restaurant.status.rawValue
        
        sortValueLabel.text = sortOption.rawValue + ": " + info.sortValue
        
        applyStyling(forStatus: restaurant.status, sortOption: sortOption)
        applyStylingForFavouriteButton()
    }
}

// MARK: - Styling

private extension RestaurantsTableViewCell {
    func applyStyling() {
        selectionStyle = .none
    }

    func applyStyling(forStatus status: OpeningState, sortOption: SortOption) {
        
        var statusColor: UIColor
        switch status {
        case .open:
            statusColor = .systemGreen
        case .orderAhead:
            statusColor = .systemBlue
        case .closed:
            statusColor = .systemRed
        }
        
        statusLabel.textColor = statusColor
    }
    
    func applyStylingForFavouriteButton() {
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
        applyStylingForFavouriteButton()

        delegate?.restaurantsTableViewCellDidTapFavourite(self, restaurantName: restaurantName)
    }
}

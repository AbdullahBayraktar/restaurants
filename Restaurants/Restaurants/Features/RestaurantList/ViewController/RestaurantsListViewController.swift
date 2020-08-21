//
//  RestaurantsListViewController.swift
//  Restaurants
//
//  Created by Abdullah Bayraktar on 18.08.2020.
//  Copyright © 2020 Abdullah Bayraktar. All rights reserved.
//

import UIKit

final class RestaurantsListViewController: UIViewController {
    
    /// Outlets
    @IBOutlet private weak var tableView: UITableView!
    
    /// View model
    var viewModel: RestaurantsListViewModel!
    
    /// Router
    var router: RestaurantsListRouter!

    // MARK: - Factory

    func initialize() {
        let dataController = RestaurantsDataController()
        viewModel = RestaurantsListViewModel(with: dataController)
        router = RestaurantsListRouter()
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialize()
        prepareViews()
        bindViewModel()
        viewModel.retrieveRestaurants()
    }
}

// MARK: - Views

private extension RestaurantsListViewController {
    
    func prepareViews() {
        setupTableView()
    }
    
    func setupTableView() {
        tableView.register(cellType: RestaurantsTableViewCell.self, bundle: nil)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .singleLine
        tableView.tableFooterView = UIView()
    }
}

// MARK: - Change Handler

private extension RestaurantsListViewController {

    func bindViewModel() {
        viewModel.stateChangeHandler = { [unowned self] change in
            self.applyStateChange(change)
        }
    }

    func applyStateChange(_ change: RestaurantsListState.Change) {
        DispatchQueue.main.async {
            switch change {
            case .restaurants(let areAvailable):
                if areAvailable {
                    self.tableView.reloadData()
                }
            }
        }
    }
}

//
//  RestaurantsListViewController.swift
//  Restaurants
//
//  Created by Abdullah Bayraktar on 18.08.2020.
//  Copyright © 2020 Abdullah Bayraktar. All rights reserved.
//

import UIKit

final class RestaurantsListViewController: UIViewController {
    
    /// Enums
    private enum Frame {
        static let picker: CGRect = CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 300)
        static let toolbar: CGRect = CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 50)
    }
    
    /// Outlets
    @IBOutlet private weak var tableView: UITableView!
    
    /// Properties
    private var pickerView: UIPickerView?
    private var toolBar: UIToolbar?
    
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
        title = "Restaurants"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.up.arrow.down.square"), style: .plain, target: self, action: #selector(sortButtonTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchButtonTapped))
        setupTableView()
    }
    
    func setupTableView() {
        tableView.register(cellType: RestaurantsTableViewCell.self, bundle: nil)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .singleLine
        tableView.tableFooterView = UIView()
    }
    
    func showPickerView() {
        let pickerView = UIPickerView(frame: Frame.picker)
        pickerView.delegate = self
        pickerView.dataSource = self
        
        pickerView.contentMode = .bottom
        pickerView.backgroundColor = UIColor.secondarySystemBackground
        pickerView.setValue(UIColor.label, forKey: "textColor")
        pickerView.autoresizingMask = .flexibleWidth

        self.pickerView = pickerView
        
        if let index = SortOption.allCases.firstIndex(where: { $0 == viewModel.selectedSortOption }) {
            pickerView.selectRow(index, inComponent: 0, animated: false)
        }
        
        view.addSubview(pickerView)
    }
    
    func showToolbar() {
        let toolBar = UIToolbar(frame: Frame.toolbar)
        
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        
        let rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(pickerToolbarDoneButtonTapped))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([flexibleSpace, flexibleSpace, rightBarButtonItem], animated: false)
        
        self.toolBar = toolBar
        view.addSubview(toolBar)
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

// MARK: - Actions

extension RestaurantsListViewController {
    
    @objc func sortButtonTapped(_ sender: UIButton) {
        guard pickerView == nil else {
            return
        }
        showPickerView()
        showToolbar()
    }
    
    @objc func searchButtonTapped(_ sender: UIButton) {
        // TODO: Navigate to Search
    }
    
    @objc func pickerToolbarDoneButtonTapped() {
        toolBar?.removeFromSuperview()
        pickerView?.removeFromSuperview()
        toolBar = nil
        pickerView = nil
    }
}

// MARK: - RestaurantsTableViewCellDelegate

extension RestaurantsListViewController: RestaurantsTableViewCellDelegate {
    func restaurantsTableViewCellDidTapFavourite(_ cell: UITableViewCell, restaurantName: String) {
        viewModel.togglefavouriteRestaurant(name: restaurantName)
    }
}

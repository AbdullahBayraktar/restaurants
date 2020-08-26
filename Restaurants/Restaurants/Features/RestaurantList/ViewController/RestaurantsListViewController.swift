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
    private let searchController = UISearchController(searchResultsController: nil)
    
    /// View model
    var viewModel: RestaurantsListViewModel!

    // MARK: - Factory

    func initialize() {
        let dataController = RestaurantsDataController()
        viewModel = RestaurantsListViewModel(with: dataController)
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialize()
        prepareViews()
        bindViewModel()
        addKeyboardNotifications()
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
        setupSearchController()
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
        
        let titleButton = UIBarButtonItem(title: "Sort by", style: .plain, target: nil, action: nil)
        titleButton.isEnabled = false
        titleButton.setTitleTextAttributes([.foregroundColor : UIColor.label], for: .disabled)
        
        toolBar.setItems([flexibleSpace, titleButton, flexibleSpace, rightBarButtonItem], animated: false)
        
        self.toolBar = toolBar
        view.addSubview(toolBar)
    }
    
    func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        
        navigationItem.searchController = searchController
        definesPresentationContext = true
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
            case .filteredRestaurants(let areFiltered):
                if areFiltered {
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
        present(searchController, animated: true, completion: nil)
        searchController.searchBar.becomeFirstResponder()
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

// MARK: - Keyboard

private extension RestaurantsListViewController {
    
    func addKeyboardNotifications() {
        let notificationCenter = NotificationCenter.default
        
        notificationCenter.addObserver(
            forName: UIResponder.keyboardWillChangeFrameNotification,
            object:nil,
            queue: .main) { (notification) in
                self.handleKeyboard(notification: notification)
        }
        notificationCenter.addObserver(
            forName: UIResponder.keyboardWillHideNotification,
            object: nil,
            queue: .main) { (notification) in
                self.handleKeyboard(notification: notification)
        }
    }
    
    func handleKeyboard(notification: Notification) {
      guard notification.name == UIResponder.keyboardWillChangeFrameNotification else {
        view.layoutIfNeeded()
        return
      }

      UIView.animate(withDuration: 0.1, animations: { () -> Void in
        self.view.layoutIfNeeded()
      })
    }
}

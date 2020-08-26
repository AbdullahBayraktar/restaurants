//
//  RestaurantsListViewModelTests.swift
//  RestaurantsTests
//
//  Created by Abdullah Bayraktar on 18.08.2020.
//  Copyright © 2020 Abdullah Bayraktar. All rights reserved.
//

import XCTest
@testable import Restaurants

private typealias ViewModel = RestaurantsListViewModel
private typealias Change = RestaurantsListState.Change

private class Box {

    let viewModel: ViewModel
    var changes: [Change] = []

    init(with dataController: RestaurantsDataProtocol = RestaurantsDummyDataController()) {
        viewModel = RestaurantsListViewModel(with: dataController)
        viewModel.stateChangeHandler = { [unowned self] change in
            self.changes.append(change)
        }
    }
}

final class RestaurantsListViewModelTests: XCTestCase {

    private var error: Error?
    private var box: Box!

    override func setUp() {
        super.setUp()
        initializeBox()
    }

    private func initializeBox() {
        box = Box()
    }
    
    override func tearDown() {
        super.tearDown()
        box = Box()
    }
}

// MARK: - Test Cases

extension RestaurantsListViewModelTests {

    func testRetrieveRestaurantsSuccessfully() {
        // Given: a provider while initialization
        let provider = RestaurantsDummyDataController()
        let box = Box(with: provider)
        
        // When: retrieve data
        box.viewModel.retrieveRestaurants()

        // Then: fetching restaurants is a success
        XCTAssert(box.changes[0] == Change.restaurants(true))
    }
    
    func testFilterRestaurantsSuccessfully() {
        // Given: a data provider and search text
        let provider = RestaurantsDummyDataController()
        let box = Box(with: provider)
        let searchText = "sushi"
        
        // When: filter restaurants
        box.viewModel.filterRestaurants(forSearchText: searchText)

        // Then: filtering restaurants is a success
        XCTAssert(box.changes[0] == Change.filteredRestaurants(true))
        XCTAssertFalse(box.changes[0] == Change.restaurants(true))
    }
}

// MARK: - Equatable Extensions

extension RestaurantsListState.Change: Equatable {

    public static func == (lhs: RestaurantsListState.Change,
                           rhs: RestaurantsListState.Change) -> Bool {
        switch (lhs, rhs) {
        case let ((.restaurants(lhsAvailable)),
                  (.restaurants(rhsAvailable))):
            return lhsAvailable == rhsAvailable
        case let ((.filteredRestaurants(lhsFiltered)),
                  (.filteredRestaurants(rhsFiltered))):
            return lhsFiltered == rhsFiltered
        default:
            return false
        }
    }
}

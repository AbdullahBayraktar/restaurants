//
//  RestaurantSortHandlerTests.swift
//  RestaurantsTests
//
//  Created by Abdullah Bayraktar on 26.08.20.
//  Copyright © 2020 Abdullah Bayraktar. All rights reserved.
//

import XCTest
@testable import Restaurants

final class RestaurantSortHandlerTests: XCTestCase {
    
    private var sut = RestaurantSortHandler.self
    
    private var restaurants: [Restaurant]!
    private var sortingValuesZanzaiRestaurant: SortingValues!
    
    override func setUp() {
        super.setUp()
        
        let zenzaiSushiSortingValues = SortingValues(
            bestMatch: 13.0,
            newest: 155.0,
            ratingAverage: 4.0,
            distance: 2911,
            popularity: 36.0,
            averageProductPrice: 1579,
            deliveryCosts: 0,
            minCost: 2000)
        sortingValuesZanzaiRestaurant = zenzaiSushiSortingValues
        
        let restaurant1 = Restaurant(name: "Zenzai Bar", status: .closed, sortingValues: zenzaiSushiSortingValues)
        
        let tanoshiiSushiBarSortingValues = SortingValues(
            bestMatch: 0.0,
            newest: 96.0,
            ratingAverage: 4.5,
            distance: 1190,
            popularity: 17.0,
            averageProductPrice: 1536,
            deliveryCosts: 200,
            minCost: 1000)

        let restaurant2 = Restaurant(name: "Tanoshii Sushi", status: .open, sortingValues: tanoshiiSushiBarSortingValues)
    
        restaurants = [restaurant1, restaurant2]
    }
    
    override func tearDown() {
        super.tearDown()
        
        restaurants = nil
        sortingValuesZanzaiRestaurant = nil
    }
    
    func testSortRestaurantsAccordingToOpeningState() {
        // Given: restaurants list
        // When:
        let sortedRestaurants = sut.sortAccordingToOpeningState(restaurants)
        
        // Then:
        XCTAssertTrue(sortedRestaurants.first?.name == "Tanoshii Sushi")
        XCTAssertTrue(sortedRestaurants.last?.name == "Zenzai Bar")
    }
    
    func testSortRestaurantsAccordingToBestMatch() {
        // Given: restaurants list and sort option
        let sortOption = SortOption.bestMatch
        
        // When:
        let sortedRestaurants = sut.sortRestaurants(restaurants, sortOption: sortOption)
        
        // Then:
        XCTAssertTrue(sortedRestaurants.first?.name == "Zenzai Bar")
        XCTAssertTrue(sortedRestaurants.last?.name == "Tanoshii Sushi")
    }
    
    func testSortRestaurantsAccordingToAverageProductPrice() {
        // Given: restaurants list and sort option
        let sortOption = SortOption.averageProductPrice
        
        // When:
        let sortedRestaurants = sut.sortRestaurants(restaurants, sortOption: sortOption)
        
        // Then:
        XCTAssertTrue(sortedRestaurants.first?.name == "Tanoshii Sushi")
        XCTAssertTrue(sortedRestaurants.last?.name == "Zenzai Bar")
    }
    
    func testSortingValueTextForAverageProductPrice() {
        // Given: restaurants list and sort option
        let sortOption = SortOption.averageProductPrice
        
        // When:
        let sortingValue = sut.sortingValueText(for: sortOption, sortingValues: sortingValuesZanzaiRestaurant)
        
        // Then:
        XCTAssertTrue(sortingValue == "1579")
    }
    
}

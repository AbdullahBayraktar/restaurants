//
//  Restaurant.swift
//  Restaurants
//
//  Created by Abdullah Bayraktar on 19.08.2020.
//  Copyright © 2020 Abdullah Bayraktar. All rights reserved.
//

struct Restaurant: Decodable {
    let name: String
    let status: OpeningState
    let sortingValues: SortingValues
}

//
//  OpeningState.swift
//  Restaurants
//
//  Created by Abdullah Bayraktar on 19.08.2020.
//  Copyright © 2020 Abdullah Bayraktar. All rights reserved.
//

enum OpeningState: String, Decodable {
    case open = "open"
    case orderAhead = "order ahead"
    case closed = "closed"
}

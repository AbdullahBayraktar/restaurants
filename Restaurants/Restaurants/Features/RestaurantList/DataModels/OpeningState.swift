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

extension OpeningState: Comparable {
    static func < (lhs: OpeningState, rhs: OpeningState) -> Bool {
        switch (lhs, rhs) {
        case (.open, .orderAhead),
             (.open, .closed):
            return true
        case (.orderAhead, .closed):
            return true
        default:
            return false
        }
    }
}

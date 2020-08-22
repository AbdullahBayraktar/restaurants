//
//  Collection+Separation.swift
//  Restaurants
//
//  Created by Abdullah Bayraktar on 23.08.20.
//  Copyright © 2020 Abdullah Bayraktar. All rights reserved.
//

import Foundation

extension Collection {
    func separate(predicate: (Element) -> Bool) -> (matching: [Element], notMatching: [Element]) {
        var groups: ([Element],[Element]) = ([],[])
        for element in self {
            if predicate(element) {
                groups.0.append(element)
            } else {
                groups.1.append(element)
            }
        }
        return groups
    }
}

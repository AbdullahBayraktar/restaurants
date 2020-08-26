//
//  Measurement+DisplayText.swift
//  Restaurants
//
//  Created by Abdullah Bayraktar on 26.08.20.
//  Copyright © 2020 Abdullah Bayraktar. All rights reserved.
//

import Foundation

extension MeasurementFormatter {
    static func displayText(for distance: Int) -> String {
        let measurementFormatter = MeasurementFormatter()
        measurementFormatter.locale = Locale.current

        let measurement = Measurement(value: Double(distance), unit: UnitLength.meters)

        return measurementFormatter.string(from: measurement)
    }
}

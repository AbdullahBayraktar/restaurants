//
//  RestaurantsListViewController+UIPickerView.swift
//  Restaurants
//
//  Created by Abdullah Bayraktar on 21.08.2020.
//  Copyright © 2020 Abdullah Bayraktar. All rights reserved.
//

import UIKit

// MARK: - UIPickerViewDataSource

extension RestaurantsListViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return SortOption.allCases.count
    }
}

// MARK: - UIPickerViewDelegate

extension RestaurantsListViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        for (index, sortOption) in SortOption.allCases.enumerated() {
            if index == row {
                return sortOption.rawValue
            }
        }
        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        for (index, sortOption) in SortOption.allCases.enumerated() {
            if index == row {
                viewModel.selectedSortOption = sortOption
                break
            }
        }
    }
}

//
//  MealDetailExt.swift
//  Fetch Meals
//
//  Created by Karon Bell on 11/7/23.
//
//

import Foundation
import SwiftUI



extension MealDetail {
    func ingredient(at index: Int) -> String? {
        switch index {
        case 1:
            return strIngredient1
        case 2:
            return strIngredient2
        case 3:
            return strIngredient3
        case 4:
            return strIngredient4
        case 5:
            return strIngredient5
        case 6:
            return strIngredient6
        case 7:
            return strIngredient7
        case 8:
            return strIngredient8
        case 9:
            return strIngredient9
        case 10:
            return strIngredient10
        case 11:
            return strIngredient11
        case 12:
            return strIngredient12
        case 13:
            return strIngredient13
        case 14:
            return strIngredient14
        case 15:
            return strIngredient15
        case 16:
            return strIngredient16
        case 17:
            return strIngredient17
        case 18:
            return strIngredient18
        case 19:
            return strIngredient19
        case 20:
            return strIngredient20
        default:
            return nil
        }
    }
}


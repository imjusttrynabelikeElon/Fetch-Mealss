//
//  ListOfMealsModel.swift
//  Fetch Meals
//
//  Created by Karon Bell on 11/6/23.
//
//

import Foundation
import SwiftUI



struct Meal: Identifiable, Codable {
    var idMeal: String
    let strMeal: String
    
    var id: String {
        return idMeal
    }
}





struct MealDetail: Decodable {
    let idMeal: String
    let strMeal: String
  
}

struct MealsResponse: Decodable {
    let meals: [Meal]
}

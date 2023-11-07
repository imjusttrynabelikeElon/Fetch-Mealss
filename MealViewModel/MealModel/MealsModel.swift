//
//  ListOfMealsModel.swift
//  Fetch Meals
//
//  Created by Karon Bell on 11/6/23.
//
//
//
//

import Foundation
import SwiftUI
import Alamofire

struct Meal: Identifiable, Codable {
    var idMeal: String
    let strMeal: String
    let strMealThumb: String
  

    var id: String {
        return idMeal
    }

   
}




struct MealDetail: Decodable {
    let strInstructions: String
    let strIngredient1: String?
    let strIngredient2: String?
    let strIngredient3: String?
    let strIngredient4: String?
    let strIngredient5: String?
    let strIngredient6: String?
    let strIngredient7: String?
    let strIngredient8: String?
    let strIngredient9: String?
    let strIngredient10: String?
    let strIngredient11: String?
    let strIngredient12: String?
    let strIngredient13: String?
    let strIngredient14: String?
    let strIngredient15: String?
    let strIngredient16: String?
    let strIngredient17: String?
    let strIngredient18: String?
    let strIngredient19: String?
    let strIngredient20: String?
}







struct MealsResponse: Decodable {
    let meals: [Meal]
}

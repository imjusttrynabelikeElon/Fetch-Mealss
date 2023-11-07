//
//  ListOfMealsModel.swift
//  Fetch Meals
//
//  Created by Karon Bell on 11/6/23.
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
   
}







struct MealsResponse: Decodable {
    let meals: [Meal]
}

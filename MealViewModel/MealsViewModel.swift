//
//  MealsViewModel.swift
//  Fetch Meals
//
//  Created by Karon Bell on 11/6/23.
//
//

import Foundation
import Combine
import Alamofire

class MealsViewModel: ObservableObject {
    @Published var meals: [Meal] = [] //  array to store meals
    @Published var selectedMeal: MealDetail?
    
    private var cancellables: Set<AnyCancellable> = []
    
    // Method to fetch dessert meals
    func fetchDessertMeals() {
        let dessertURL = URL(string: "https://www.themealdb.com/api/json/v1/1/filter.php?c=Dessert")!
        
        // heres alamofire to make a network request
        AF.request(dessertURL).responseDecodable(of: MealsResponse.self) { response in
            switch response.result {
            case .success(let decodedData):
                self.meals = decodedData.meals 
            case .failure(let error):
                print("Error fetching dessert meals: \(error)")
            }
        }
    }
    
    func fetchMealDetails(for mealID: String) {
        let mealURLString = "https://www.themealdb.com/api/json/v1/1/lookup.php?i=\(mealID)"
        guard let mealURL = URL(string: mealURLString) else {
            print("Invalid URL: \(mealURLString)")
            return
        }

        
        struct MealDetailResponse: Decodable {
            let meals: [MealDetail]
        }

        AF.request(mealURL).responseDecodable(of: MealDetailResponse.self) { response in
            switch response.result {
            case .success(let mealDetailResponse):
                if let mealDetail = mealDetailResponse.meals.first {
                    //  im Printing the details from MealDetail
                    print("Instructions: \(mealDetail.strInstructions)")
                    if let ingredient1 = mealDetail.strIngredient1 {
                        print("Ingredient 1: \(ingredient1)")
                    } else {
                        print("Ingredient 1 not available")
                    }
            
                } else {
                    print("Meal detail not found in the response")
                }
            case .failure(let error):
                print("Error fetching meal details: \(error)")
            }
        }
    }

}

//
//  MealsViewModel.swift
//  Fetch Meals
//
//  Created by Karon Bell on 11/6/23.
//
//
// im thinking about adding one more feature after the app is on github.

import Foundation
import Combine

import Foundation
import Combine

/// A view model for managing meal-related data.
class MealsViewModel: ObservableObject {
    /// An array of meals retrieved from the API.
    @Published var meals: [Meal] = []

    /// The selected meal for detailed view.
    @Published var selectedMeal: MealDetail?

    /// The detailed information for a specific meal.
    @Published var mealDetail: MealDetail?
    
    /// Set of cancellables to manage Combine subscriptions.
    private var cancellables: Set<AnyCancellable> = []

    /// Fetches dessert meals from the API and updates the `meals` property.
    ///
    ///
    func fetchDessertMeals() {
        let dessertURL = URL(string: "https://www.themealdb.com/api/json/v1/1/filter.php?c=Dessert")!

        URLSession.shared.dataTaskPublisher(for: dessertURL)
            .map(\.data)
            .decode(type: MealsResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main) // Ensure updates are on the main thread
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error fetching dessert meals: \(error)")
                }
            } receiveValue: { [weak self] decodedData in
                self?.meals = decodedData.meals
            }
            .store(in: &cancellables)
    }

    /// Fetches detailed information for a specific meal identified by `mealID`.
    ///
    /// - Parameters:
    ///   - mealID: The unique identifier of the meal.
    func fetchMealDetails(for mealID: String) {
        let mealURLString = "https://www.themealdb.com/api/json/v1/1/lookup.php?i=\(mealID)"
        guard let mealURL = URL(string: mealURLString) else {
            print("Invalid URL: \(mealURLString)")
            return
        }

        URLSession.shared.dataTaskPublisher(for: mealURL)
            .map(\.data)
            .decode(type: MealDetailResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main) // Ensure updates are on the main thread
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error fetching meal details: \(error)")
                }
            } receiveValue: { [weak self] mealDetailResponse in
                if let mealDetail = mealDetailResponse.meals.first {
                    self?.mealDetail = mealDetail
                } else {
                    print("Meal detail not found in the response")
                }
            }
            .store(in: &cancellables)
    }
}

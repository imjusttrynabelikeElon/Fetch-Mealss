//
//  MealsViewModel.swift
//  Fetch Meals
//
//  Created by Karon Bell on 11/6/23.
//


import Foundation
import Combine
import SwiftUI



class MealsViewModel: ObservableObject {
    @Published var meals: [Meal] = []
    @Published var selectedMeal: MealDetail?

    private var cancellables: Set<AnyCancellable> = []
    
    func fetchDessertMeals() {
        let dessertURL = URL(string: "https://www.themealdb.com/api/json/v1/1/filter.php?c=Dessert")!

        URLSession.shared.dataTaskPublisher(for: dessertURL)
            .map(\.data)
            .tryMap { data in
                do {
                    let decodedData = try JSONDecoder().decode(MealsResponse.self, from: data)
                    return decodedData.meals
                } catch {
                    throw error
                }
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("API request failed: \(error)")
                }
            }, receiveValue: { [weak self] meals in
                self?.meals = meals
            })
            .store(in: &cancellables)
    }



    func fetchMealDetails(for meals: [Meal]) {
        var mealDetailPublishers: [AnyPublisher<Meal?, Never>] = []

        for meal in meals {
            let mealID = meal.id
            let url = URL(string: "https://www.themealdb.com/api/json/v1/1/lookup.php?i=\(String(describing: mealID))")

            guard let mealURL = url else {
                print("Invalid URL for meal ID: \(mealID)")
                continue
            }

            let mealDetailPublisher = URLSession.shared.dataTaskPublisher(for: mealURL)
                .map(\.data)
                .decode(type: MealsResponse.self, decoder: JSONDecoder())
                .map { response in
                    return response.meals.first
                }
                .replaceError(with: nil)
                .eraseToAnyPublisher()

            mealDetailPublishers.append(mealDetailPublisher)
        }

        Publishers.MergeMany(mealDetailPublishers)
            .collect()
            .receive(on: DispatchQueue.main)
            .sink { mealDetails in
                print("Meal details fetched: \(mealDetails.count)")
                // Handle the array of meal details here
                print(mealDetails)
            }
            .store(in: &cancellables)
    }
    
}

//
//  ContentView.swift
//  Fetch Meals
//
//  Created by Karon Bell on 11/6/23.
//



import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: MealsViewModel

    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.meals) { meal in
                    NavigationLink(destination: MealDetailView(meal: meal)) {
                        Text(meal.strMeal)
                    }
                }
            }
            .navigationBarTitle("Dessert Meals")
        }
        .onAppear {
            viewModel.fetchDessertMeals()
        }
    }

    
    
    struct MealDetailView: View {
        var meal: Meal
        
        var body: some View {
            VStack {
                Text("ID: \(meal.id)")
                Text(meal.strMeal)
            }
            .onAppear {
                print("MealDetailView appeared for meal ID: \(meal.id)")
            }
        }
        static var previews: some View {
            ContentView(viewModel: MealsViewModel())
        }
        
    }
}

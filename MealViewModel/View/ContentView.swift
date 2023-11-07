//
//  ContentView.swift
//  Fetch Meals
//
//  Created by Karon Bell on 11/6/23.
//
//
//
import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: MealsViewModel

    var body: some View {
        NavigationView {
            List(viewModel.meals, id: \.id) { meal in
                NavigationLink(destination: MealDetailView(viewModel: viewModel, meal: meal)) {
                    HStack {
                        if let strMealThumb = meal.strMealThumb, let url = URL(string: strMealThumb) {
                          
                            AsyncImage(url: url) { phase in
                                if let image = phase.image {
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 50, height: 50)
                                        .clipShape(Circle())
                                } else if phase.error != nil {
                                    
                                    Text("Image Load Error")
                                } else {
                                    // Placeholder while loading
                                    ProgressView()
                                }
                            }
                            .frame(width: 50, height: 50)
                        }

                      
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

 
          
}



struct MealDetailView: View {
    @ObservedObject var viewModel: MealsViewModel
    var meal: Meal

    @State private var isLoading: Bool = true

    var body: some View {
        VStack {
            Text("ID: \(meal.id)")
            if let mealDetail = viewModel.selectedMeal {
                Text("Instructions: \(mealDetail.strInstructions)")
            }
        }
        .onAppear {
            viewModel.fetchMealDetails(for: meal.id) // Fetch meal details when the view appears
        }
        .onReceive(viewModel.$selectedMeal) { selectedMeal in
            isLoading = selectedMeal == nil
        }
    }
}

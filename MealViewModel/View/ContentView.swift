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
    
    @StateObject var viewModel = MealsViewModel()
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
        ScrollView {
            VStack(alignment: .center) {
                Text("Fetch Recipe For \(meal.strMeal)")
                    .font(.title)
                    .padding(.vertical, 10)

                // the meal thumbnail
                if let strMealThumb = meal.strMealThumb, let url = URL(string: strMealThumb) {
                    AsyncImage(url: url) { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                        } else if phase.error != nil {
                            Text("Image Load Error")
                        } else {
                            ProgressView()
                        }
                    }
                    .padding(.vertical, 10)
                }

                if !isLoading {
                    if let mealDetail = viewModel.mealDetail {
                        Text("Instructions:")
                            .font(.title2)
                            .padding(.top, 10)

                        Text(mealDetail.strInstructions)
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.horizontal, 20)

                        // im looping through ingredients, filter out empty ones, and display them
                        ForEach(1...20, id: \.self) { index in
                            if let ingredient = mealDetail.ingredient(at: index), !ingredient.isEmpty {
                                Text("Ingredient \(index): \(ingredient)")
                                    .padding(.horizontal, 20)
                            }
                        }
                    } else {
                        Text("Meal detail not found")
                    }
                } else {
                    ProgressView()
                }
            }
            .padding(.horizontal, 20)
            .multilineTextAlignment(.center)
        }
        .onAppear {
            // Fetching meal details when the view appears
            viewModel.fetchMealDetails(for: meal.id)
        }
        .onReceive(viewModel.$mealDetail) { mealDetail in
            isLoading = mealDetail == nil
        }
    }
}

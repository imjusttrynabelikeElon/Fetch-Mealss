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
                NavigationLink(destination: MealDetailView(meal: meal)) {
                    HStack {
                        if let strMealThumb = meal.strMealThumb, let url = URL(string: strMealThumb) {
                            // Display the meal thumbnail as an Image
                            AsyncImage(url: url) { phase in
                                if let image = phase.image {
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 50, height: 50)
                                        .clipShape(Circle())
                                } else if phase.error != nil {
                                    // Handle error if image loading fails
                                    Text("Image Load Error")
                                } else {
                                    // Placeholder while loading
                                    ProgressView()
                                }
                            }
                            .frame(width: 50, height: 50)
                        }

                        // Display the meal name as Text
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
                Text(meal.idMeal.description)

          
                if let strMealThumb = meal.strMealThumb, let url = URL(string: strMealThumb) {
                    // Display the meal thumbnail as an Image
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
                            ProgressView()
                        }
                    }
                    .frame(width: 50, height: 50)
                } else {
                    Text("Thumbnail not available")
                }
            }
            .onAppear {
                print("MealDetailView appeared for meal ID: \(meal.id)")
                print(meal.strMeal)
            }
        }
    }

 
          
}

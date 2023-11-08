//
//  ContentView.swift
//  Fetch Meals
//
//  Created by Karon Bell on 11/6/23.
//
//
//
//

import SwiftUI
import Intents
import Speech
import AVFoundation

struct ContentView: View {
    @StateObject var viewModel = MealsViewModel()

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible(minimum: 0, maximum: .infinity), spacing: 10), GridItem(.flexible(minimum: 0, maximum: .infinity), spacing: 10)], spacing: 10) {
                    ForEach(viewModel.meals, id: \.id) { meal in
                        NavigationLink(destination: MealDetailView(viewModel: viewModel, meal: meal)) {
                            ZStack(alignment: .bottom) {
                                if let strMealThumb = meal.strMealThumb, let url = URL(string: strMealThumb) {
                                    AsyncImage(url: url) { phase in
                                        if let image = phase.image {
                                            image
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 160, height: 250)
                                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                        } else if phase.error != nil {
                                            Text("Image Load Error")
                                        } else {
                                            ProgressView()
                                        }
                                    }
                                    .frame(width: 160, height: 160)
                                }
                                Text(meal.strMeal)
                                    .foregroundColor(.white)
                                    .font(.title)
                                    .padding()
                                    .shadow(color: Color.black, radius: 6.5, x: 0, y: 0)

                                    
                            }
                            
                            .frame(width: 160, height: 257)
                        }
                    }
                }
                
            }
            .navigationBarTitle("Dessert Meals")
        }
        .padding()
        .onAppear {
            viewModel.fetchDessertMeals()
        }
    }
}


struct MealDetailView: View {
    @ObservedObject var viewModel: MealsViewModel
    var meal: Meal

    @State private var isLoading: Bool = true
    @State private var isImageTapped: Bool = false
    @State private var isPlaying: Bool = false
    @State private var isStopping: Bool = false
    let synthesizer = AVSpeechSynthesizer()

    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 10) {
                // Name of the recipe
                Text(meal.strMeal)
                    .font(.title)
                    .bold()
                    .padding(.vertical, 10)

                if let strMealThumb = meal.strMealThumb, let url = URL(string: strMealThumb) {
                    AsyncImage(url: url) { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                                .onTapGesture {
                                    isImageTapped.toggle()
                                }
                        } else if phase.error != nil {
                            Text("Image Load Error")
                        } else {
                            ProgressView()
                        }
                    }
                    .padding(.vertical, 10)
                    .sheet(isPresented: $isImageTapped) {
                        // Full-screen version of the image in a modal view
                        if let strMealThumb = meal.strMealThumb, let url = URL(string: strMealThumb) {
                            Text("\(meal.strMeal)")
                                .font(.headline)
                                .bold()
                            AsyncImage(url: url) { phase in
                                if let image = phase.image {
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                } else if phase.error != nil {
                                    Text("Image Load Error")
                                } else {
                                    ProgressView()
                                }
                            }
                            Text("Yum! 🤤 It looks Greatt")
                                .fontWeight(.medium)
                                .padding()
                                .onTapGesture {
                                    isImageTapped.toggle() // dismiss the modal view
                                }
                        }
                    }
                }

                HStack {
                    Button(action: {
                        if isPlaying {
                            isStopping = true
                            synthesizer.stopSpeaking(at: .immediate)
                        } else {
                            isStopping = false
                            startSpeechSynthesis(instructions: viewModel.mealDetail?.strInstructions ?? "No instructions available")
                        }
                        isPlaying.toggle()
                    }) {
                        Text(isPlaying ? "Stop" : "Play") // Change the button label dynamically
                            .font(.title)
                            .frame(width: 100, height: 50)
                            .background(isPlaying ? Color.red : Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(25)
                    }
                    .padding(.horizontal)
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

                        Divider() // Add a divider line

                        Text("Ingredients:")
                            .font(.title2)
                            .padding(.top, 10)

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
            viewModel.fetchMealDetails(for: meal.id)
        }
        .onReceive(viewModel.$mealDetail) { mealDetail in
            isLoading = mealDetail == nil
        }
        .onDisappear {
                    // Stops the speech when the view disappears
                    if isPlaying {
                        isStopping = true
                        synthesizer.stopSpeaking(at: .immediate)
                        isPlaying = false
                    }
                }
    }
    
    
    func startSpeechSynthesis(instructions: String) {
      
        let speechUtterance = AVSpeechUtterance(string: instructions)
        speechUtterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        speechUtterance.rate = 0.4
        synthesizer.speak(speechUtterance)
        
    }
}


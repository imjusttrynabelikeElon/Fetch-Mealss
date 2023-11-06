//
//  Fetch_MealsApp.swift
//  Fetch Meals
//
//  Created by Karon Bell on 11/6/23.
//

import SwiftUI

@main
struct Fetch_MealsApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: MealsViewModel())
        }
    }
}

//
//  ToncheAPIApp.swift
//  ToncheAPI
//
//  Created by kreb on 10/7/26.
//
import SwiftUI

@main
struct ToncheAPIApp: App {
    var body: some Scene {
        WindowGroup {
            MealListView()
                .tint(.orange)
        }
    }
}

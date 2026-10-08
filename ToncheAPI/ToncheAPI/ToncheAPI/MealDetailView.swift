//
//  MealDetailView.swift
//  ToncheAPI
//
//  Created by kreb on 10/7/26.
//
import SwiftUI

// Responsabilidad única: presentar una receta ya cargada.
struct MealDetailView: View {
    let meal: Meal

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                MealImageView(url: meal.imageURL)
                    .frame(height: 260)
                    .clipShape(
                        RoundedRectangle(cornerRadius: 20)
                    )

                VStack(alignment: .leading, spacing: 8) {
                    Text(meal.name)
                        .font(.largeTitle.bold())
                        .accessibilityAddTraits(.isHeader)

                    Text("\(meal.category) · \(meal.area)")
                        .foregroundStyle(.secondary)
                }

                VStack(alignment: .leading, spacing: 12) {
                    heading("Ingredientes")

                    if meal.ingredients.isEmpty {
                        Text("Ingredientes no disponibles.")
                    }

                    ForEach(meal.ingredients) { ingredient in
                        Text(
                            ingredient.measure.isEmpty
                                ? ingredient.name
                                : "\(ingredient.measure) · \(ingredient.name)"
                        )
                    }
                }

                VStack(alignment: .leading, spacing: 12) {
                    heading("Preparación")

                    Text(
                        meal.instructions
                            .trimmingCharacters(in: .whitespacesAndNewlines)
                            .isEmpty
                            ? "Instrucciones no disponibles."
                            : meal.instructions
                    )
                    .lineSpacing(6)
                    .textSelection(.enabled)
                }

                Text(
                    "Fuente: TheMealDB · Contenido original en inglés"
                )
                .font(.footnote)
                .foregroundStyle(.secondary)
            }
            .padding(20)
            .frame(maxWidth: 720, alignment: .leading)
            .frame(maxWidth: .infinity)
        }
        .navigationTitle("Receta")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func heading(_ title: String) -> some View {
        Text(title)
            .font(.title2.bold())
            .accessibilityAddTraits(.isHeader)
    }
}

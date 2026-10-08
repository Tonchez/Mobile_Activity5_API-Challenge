//
//  Meal.swift
//  ToncheAPI
//
//  Created by kreb on 10/7/26.
//

import Foundation

struct Ingredient: Identifiable, Sendable {
    let id: Int
    let name: String
    let measure: String
}

// Responsabilidad única: convertir el JSON a datos del dominio.
struct Meal: Decodable, Identifiable, Sendable {
    let id: String
    let name: String
    let category: String
    let area: String
    let instructions: String
    let imageURL: URL?
    let ingredients: [Ingredient]

    private struct Key: CodingKey {
        let stringValue: String

        var intValue: Int? { nil }

        init(_ value: String) {
            stringValue = value
        }

        init?(stringValue: String) {
            self.stringValue = stringValue
        }

        init?(intValue: Int) {
            return nil
        }
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)

        id = try container.decode(
            String.self,
            forKey: Key("idMeal")
        )

        name = try container.decode(
            String.self,
            forKey: Key("strMeal")
        )

        category = try container.decodeIfPresent(
            String.self,
            forKey: Key("strCategory")
        ) ?? "Sin categoría"

        area = try container.decodeIfPresent(
            String.self,
            forKey: Key("strArea")
        ) ?? "Origen desconocido"

        instructions = try container.decodeIfPresent(
            String.self,
            forKey: Key("strInstructions")
        ) ?? ""

        let image = try container.decodeIfPresent(
            String.self,
            forKey: Key("strMealThumb")
        )

        imageURL = image
            .flatMap(URL.init(string:))
            .flatMap { $0.scheme == "https" ? $0 : nil }

        var values: [Ingredient] = []

        for index in 1...20 {
            let name = try container.decodeIfPresent(
                String.self,
                forKey: Key("strIngredient\(index)")
            )?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

            let measure = try container.decodeIfPresent(
                String.self,
                forKey: Key("strMeasure\(index)")
            )?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

            if !name.isEmpty {
                values.append(
                    Ingredient(
                        id: index,
                        name: name,
                        measure: measure
                    )
                )
            }
        }

        ingredients = values
    }
}

struct MealsResponse: Decodable, Sendable {
    let meals: [Meal]?
}

//
//  MealService.swift
//  ToncheAPI
//
//  Created by kreb on 10/7/26.
//
import Foundation

// Inversión de dependencias: el ViewModel usa un contrato inyectable.
protocol MealServing: Sendable {
    func search(_ query: String) async throws -> [Meal]
}

enum MealServiceError: LocalizedError {
    case invalidURL
    case invalidResponse
    case http(Int)
    case invalidData
    case offline
    case timeout
    case network

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            "No se pudo preparar la búsqueda."

        case .invalidResponse:
            "El servidor envió una respuesta inesperada."

        case .http(let code):
            "TheMealDB respondió con HTTP \(code). Intenta de nuevo."

        case .invalidData:
            "No se pudieron leer las recetas de TheMealDB."

        case .offline:
            "Sin conexión. Revisa tu internet e intenta de nuevo."

        case .timeout:
            "El servidor tardó demasiado. Intenta de nuevo."

        case .network:
            "No se pudo conectar con TheMealDB. Intenta de nuevo."
        }
    }
}

struct MealService: MealServing {
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func search(_ query: String) async throws -> [Meal] {
        var components = URLComponents(
            string: "https://www.themealdb.com/api/json/v1/1/search.php"
        )

        components?.queryItems = [
            URLQueryItem(name: "s", value: query)
        ]

        guard let url = components?.url else {
            throw MealServiceError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 20

        do {
            let (data, response) = try await session.data(for: request)

            guard let response = response as? HTTPURLResponse else {
                throw MealServiceError.invalidResponse
            }

            guard (200...299).contains(response.statusCode) else {
                throw MealServiceError.http(response.statusCode)
            }

            do {
                // meals:null significa que no hay resultados.
                return try JSONDecoder()
                    .decode(MealsResponse.self, from: data)
                    .meals ?? []
            } catch {
                throw MealServiceError.invalidData
            }
        } catch let error as URLError {
            switch error.code {
            case .cancelled:
                throw CancellationError()

            case .notConnectedToInternet, .networkConnectionLost:
                throw MealServiceError.offline

            case .timedOut:
                throw MealServiceError.timeout

            default:
                throw MealServiceError.network
            }
        }
    }
}

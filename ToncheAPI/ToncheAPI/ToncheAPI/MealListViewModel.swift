//
//  MealListViewModel.swift
//  ToncheAPI
//
//  Created by kreb on 10/7/26.
//
import Foundation
import Combine

enum MealListState {
    case idle
    case loading
    case loaded([Meal])
    case failed(String)
}

// El actor principal protege las actualizaciones observables.
@MainActor
final class MealListViewModel: ObservableObject {
    @Published var query = "chicken"
    @Published private(set) var state: MealListState = .idle
    @Published private(set) var submittedQuery = "chicken"

    private let service: any MealServing
    private var generation = 0

    init(service: any MealServing = MealService()) {
        self.service = service
    }

    func load() async {
        generation += 1

        let requestGeneration = generation
        let search = query.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        submittedQuery = search
        state = .loading

        do {
            let meals = try await service.search(search)
            try Task.checkCancellation()

            // Una respuesta antigua no sobrescribe la búsqueda actual.
            guard generation == requestGeneration else {
                return
            }

            state = .loaded(meals)
        } catch is CancellationError {
            if generation == requestGeneration {
                state = .idle
            }
        } catch {
            guard generation == requestGeneration else {
                return
            }

            state = .failed(error.localizedDescription)
        }
    }
}

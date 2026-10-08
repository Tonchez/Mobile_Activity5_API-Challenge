//
//   MealListView.swift
//  ToncheAPI
//
//  Created by kreb on 10/7/26.
//
import SwiftUI

struct MealListView: View {
    @StateObject private var viewModel = MealListViewModel()
    @State private var searchTask: Task<Void, Never>?

    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Mesa abierta")
                .searchable(
                    text: $viewModel.query,
                    prompt: "Receta en inglés, ej. chicken"
                )
                .onSubmit(of: .search) {
                    search()
                }
                .toolbar {
                    Button(
                        "Buscar",
                        systemImage: "magnifyingglass",
                        action: search
                    )
                    .accessibilityHint(
                        "Busca recetas por nombre en TheMealDB"
                    )
                }
                .task {
                    if case .idle = viewModel.state {
                        await viewModel.load()
                    }
                }
                .onDisappear {
                    searchTask?.cancel()
                }
        }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle:
            status(
                "Explora recetas",
                icon: "fork.knife",
                message: "Escribe un nombre y pulsa Buscar."
            )

        case .loading:
            ProgressView("Buscando recetas…")
                .frame(
                    maxWidth: .infinity,
                    maxHeight: .infinity
                )

        case .failed(let message):
            status(
                "No pudimos cargar las recetas",
                icon: "wifi.exclamationmark",
                message: message
            )

        case .loaded(let meals):
            if meals.isEmpty {
                status(
                    "Sin resultados",
                    icon: "magnifyingglass",
                    message: """
                    Prueba otro nombre en inglés. Una búsqueda \
                    vacía muestra recetas disponibles.
                    """
                )
            } else {
                List {
                    Section {
                        ForEach(meals) { meal in
                            NavigationLink {
                                MealDetailView(meal: meal)
                            } label: {
                                MealRowView(meal: meal)
                            }
                            .accessibilityHint(
                                "Abre los ingredientes y la preparación"
                            )
                        }
                    } header: {
                        Text(
                            "\(meals.count) recetas · \(viewModel.submittedQuery.isEmpty ? "Explorar" : viewModel.submittedQuery)"
                        )
                    } footer: {
                        Text(
                            "Recetas e imágenes de TheMealDB. Contenido en inglés."
                        )
                    }
                }
                .listStyle(.insetGrouped)
                .refreshable {
                    await viewModel.load()
                }
            }
        }
    }

    private func status(
        _ title: String,
        icon: String,
        message: String
    ) -> some View {
        ContentUnavailableView {
            Label(title, systemImage: icon)
        } description: {
            Text(message)
        } actions: {
            Button("Buscar de nuevo", action: search)
                .buttonStyle(.borderedProminent)
                .frame(minHeight: 44)
        }
    }

    private func search() {
        searchTask?.cancel()

        searchTask = Task {
            await viewModel.load()
        }
    }
}

// Responsabilidad única: presentar una fila de la lista.
private struct MealRowView: View {
    let meal: Meal

    @Environment(\.dynamicTypeSize) private var textSize

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            MealImageView(url: meal.imageURL)
                .frame(
                    height: textSize.isAccessibilitySize ? 180 : 140
                )
                .clipShape(
                    RoundedRectangle(cornerRadius: 14)
                )

            Text(meal.name)
                .font(.headline)

            Text("\(meal.category) · \(meal.area)")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 8)
    }
}

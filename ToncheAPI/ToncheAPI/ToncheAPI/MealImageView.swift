//
//  MealImageView.swift
//  ToncheAPI
//
//  Created by kreb on 10/7/26.
//
import SwiftUI

// DRY: lista y detalle reutilizan el mismo componente de imagen.
struct MealImageView: View {
    let url: URL?

    @State private var retryID = UUID()

    var body: some View {
        AsyncImage(url: url) { phase in
            switch phase {
            case .empty:
                if url != nil {
                    ProgressView()
                        .accessibilityLabel("Cargando imagen")
                } else {
                    placeholder
                }

            case .success(let image):
                image
                    .resizable()
                    .scaledToFill()
                    .accessibilityHidden(true)

            case .failure:
                VStack(spacing: 8) {
                    placeholder

                    Button("Reintentar imagen") {
                        retryID = UUID()
                    }
                    .font(.caption)
                    .buttonStyle(.bordered)
                    .frame(minHeight: 44)
                }

            @unknown default:
                placeholder
            }
        }
        .id(retryID)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.secondarySystemBackground))
        .clipped()
    }

    private var placeholder: some View {
        Label(
            "Imagen no disponible",
            systemImage: "photo"
        )
        .font(.caption)
        .foregroundStyle(.secondary)
        .multilineTextAlignment(.center)
        .padding(8)
    }
}

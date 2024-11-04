//
//  FavoriteView.swift
//  Dog24
//
//  Created by Kalender Usta on 13.09.24.
//

import SwiftUI

struct FavoriteView: View {
    @EnvironmentObject var viewModel: ViewModel
    @State private var showErrorAlert = false

    var body: some View {
        NavigationStack {
            VStack {
                if viewModel.favoriteProductIds.isEmpty {
                    Text("Du hast noch keine Favoriten.")
                        .font(.title2)
                        .padding()
                } else {
                    List(viewModel.favoriteProductIds, id: \.self) { productId in
                        if let product = viewModel.products.first(where: { $0.id == productId }) {
                            FavoriteRow(product: product)
                        }
                    }
                }
            }
            .navigationTitle("Favoriten")
            .onAppear {
                loadFavorites()
            }
            .alert(isPresented: $showErrorAlert) {
                Alert(
                    title: Text("Fehler"),
                    message: Text(viewModel.errorMessage ?? "Unbekannter Fehler"),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }

    private func loadFavorites() {
        viewModel.loadFavoriteProducts()
        
        if viewModel.errorMessage != nil {
            showErrorAlert = true
        }
    }
}

#Preview {
    FavoriteView()
}


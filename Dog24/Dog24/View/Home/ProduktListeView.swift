//
//  ProduktListeView.swift
//  Dog24
//
//  Created by Kalender Usta on 06.09.24.
//

import SwiftUI

struct ProduktListeView: View {
    @EnvironmentObject var viewModel: ViewModel
    let title: String
    let products: [Product]
    
    var body: some View {
        VStack {
            List(products) { product in
                NavigationLink(destination: ProductDetailView(product: product)) {
                    HStack {
                        if let url = URL(string: product.bildUrl) {
                            AsyncImage(url: url) { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 60, height: 60)
                                    .cornerRadius(8)
                            } placeholder: {
                                ProgressView()
                                    .frame(width: 60, height: 60)
                                    .background(.gray.opacity(0.3))
                                    .cornerRadius(8)
                            }
                        } else {
                            Image(systemName: "photo")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 60, height: 60)
                                .background(.gray.opacity(0.3))
                                .cornerRadius(8)
                        }
                        
                        VStack(alignment: .leading) {
                            Text(product.title)
                                .font(.headline)
                                .foregroundColor(.primary)
                            Text("\(String(format: "%.2f", product.price)) €")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.vertical, 8)
                }
            }
        }
        .navigationTitle(title)
        .onAppear {
            Task{
                await viewModel.fetchToysProducts()
            }
        }
    }
}

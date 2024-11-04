//
//  SectionView.swift
//  Dog24
//
//  Created by Kalender Usta on 12.09.24.
//

import SwiftUI

struct SectionView: View {
    let title: String
    @EnvironmentObject var viewModel: ViewModel
    @State private var showProducts = false
    
    private var products: [Product] {
        switch title {
        case "Empfehlungen":
            return viewModel.recommendedProducts
        case "Neuheiten":
            return viewModel.newArrivals
        case "Bestseller":
            return viewModel.bestSellers
        case "Beliebte Geschenke":
            return viewModel.popularGifts
        default:
            return []
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(title)
                    .bold()
                    .font(.title2)
                    .padding()
                
                Spacer()
                
                NavigationLink(destination: ProduktListeView(title: title, products: products)) {
                    Text("Anzeigen")
                        .foregroundColor(.blue)
                        .padding()
                }
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(products) { product in
                        NavigationLink(destination: ProductDetailView(product: product)){
                            ProductCard(product: product)
                        }
                    }
                }
                .padding(.horizontal)
            }
            .frame(height: 250)
        }
    }
}

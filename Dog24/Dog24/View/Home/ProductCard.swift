//
//  ProductCard.swift
//  Dog24
//
//  Created by Kalender Usta on 12.09.24.
//

import SwiftUI

struct ProductCard: View {
    let product: Product

    var body: some View {
        VStack {
            if let url = URL(string: product.bildUrl) {
                AsyncImage(url: url) { image in
                    image.resizable()
                        .scaledToFill() 
                        .frame(width: 150, height: 150)
                        .clipped()
                } placeholder: {
                    ProgressView()
                }
                .padding()
            }

            VStack(alignment: .leading, spacing: 5) {
                Text(product.title)
                    .font(.subheadline)
                    .foregroundStyle(.black)
                    .bold()
                    .lineLimit(1)
                    .truncationMode(.tail)

                Text(product.description)
                    .font(.caption)
                    .foregroundStyle(.black)
                    .lineLimit(2)
                    .truncationMode(.tail)
                    .multilineTextAlignment(.leading)
                    .padding(.top, 1)

                Text("\(String(format: "%.2f", product.price)) €")
                    .font(.caption)
                    .foregroundStyle(.black)
                    .padding(.vertical, 5)
                    .padding(.bottom)
            }
            .padding(.leading, 8)
        }
        .frame(width: 180)
        .background(.white)
        .cornerRadius(8)
        
    }
}

#Preview {
    ProductCard(product: Product(id: 1, title: "Beispielprodukt", category: Category(category: .spielzeuge, subCategories: [], image: ""), evaluation: 4, price: 29.99, description: "Eine sehr lange Beschreibung des Produkts, die hier gekürzt werden sollte, um den Platz auf der Karte zu sparen", bildUrl: "data:image/jpeg;base64,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", quantity: 2))
}

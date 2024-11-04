//
//  FavoriteRow.swift
//  Dog24
//
//  Created by Kalender Usta on 13.09.24.
//

import SwiftUI

struct FavoriteRow: View {
    let product: Product

    var body: some View {
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
                Text("\(String(format: "%.2f", product.price)) €")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }

            Spacer()
        }
        .padding()
    }
}

#Preview {
    FavoriteView()
        .environmentObject(ViewModel())
}

//
//  ProduktRow.swift
//  Dog24
//
//  Created by Kalender Usta on 10.09.24.
//

import SwiftUI

struct ProduktRow: View {
    var produkt: Product
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: produkt.bildUrl)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 50)
                    .clipShape(.circle)
            } placeholder: {
                ProgressView()
                    .frame(width: 50, height: 50)
            }
            VStack(alignment: .leading) {
                Text(produkt.title)
                    .font(.headline)
                Text("\(produkt.price, specifier: "%.2f") €")
                    .font(.subheadline)
            }
        }
    }
}

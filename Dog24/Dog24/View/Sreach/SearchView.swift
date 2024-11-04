//
//  SearchView.swift
//  Dog24
//
//  Created by Kalender Usta on 19.09.24.
//

import SwiftUI

struct SearchView: View {
    @EnvironmentObject var viewModel: ViewModel
    
    var body: some View {
        NavigationStack{
            ScrollView{
                ForEach(viewModel.products){ product in
                    NavigationLink(destination: ProductDetailView(product: product)){
                        ProductSearchView(product: product)
                    }
                }
            }
        }
        .searchable(text: $viewModel.searchTerm)
        .navigationTitle("Suche")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    SearchView()
}
